import 'dart:async';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:flutter_application_1/src/presentation/page/driver/mapLocation/bloc/DriverMapLocationEvent.dart';
import 'package:flutter_application_1/src/presentation/page/driver/mapLocation/bloc/DriverMapLocationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapLocationBloc extends Bloc<DriverMapLocationEvent, DriverMapLocationState> {
  GeolocatorUseCases geolocatorUseCases;
  StreamSubscription? positionSubscription;

  DriverMapLocationBloc(this.geolocatorUseCases) : super(DriverMapLocationState()) {
    on<DriverMapLocationInitEvent>((event, emit) {
      Completer<GoogleMapController> controller = Completer<GoogleMapController>();
      emit(state.copyWith(controller: controller));
    });

    on<FindPosition>((event, emit) async {
      Position position = await geolocatorUseCases.findPosition.run();
      add(ChangeMapCameraPosition(lat: position.latitude, lng: position.longitude));
      add(AddMyPositionMarker(lat: position.latitude, lng: position.longitude));
      Stream<Position> positionStream = geolocatorUseCases.getPositionStream.run();
      positionSubscription = positionStream.listen((Position position) {
        add(UpdateLocation(position: position));
      });

      emit(state.copyWith(
        position: position,
      ));
      print('Position Lat: ${position.latitude}');
      print('Position Lng: ${position.longitude}');
    });

    on<AddMyPositionMarker>((event, emit) async {
      BitmapDescriptor descriptor = await geolocatorUseCases.createMarker
          .run('assets/img/car_pin2.png', width: 130);
      Marker marker = geolocatorUseCases.getMarker
          .run('my_location', event.lat, event.lng, 'Mi posición', '', descriptor);
      emit(state.copyWith(
        markers: {marker.markerId: marker},
      ));
    });

    on<ChangeMapCameraPosition>((event, emit) async {
      GoogleMapController googleMapController = await state.controller!.future;
      await googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(event.lat, event.lng), zoom: 13, bearing: 0)));
    });

    on<UpdateLocation>((event, emit) {
      print(
          'ACTUALIZACION DE LOCALIZACION LAT: ${event.position.latitude} LNG: ${event.position.longitude}');
      add(AddMyPositionMarker(
          lat: event.position.latitude, lng: event.position.longitude));
      add(ChangeMapCameraPosition(
          lat: event.position.latitude, lng: event.position.longitude));
      emit(state.copyWith(position: event.position));
    });

    on<StopLocation>((event, emit) {
      positionSubscription?.cancel();
    });
  }
}
