import 'dart:async';
import 'package:flutter_application_1/src/domain/models/PlacemarkData.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/socket/SocketUseCases.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapSeeker/bloc/ClientMapSeekerEvent.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapSeeker/bloc/ClientMapSeekerState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ClientMapSeekerBloc extends Bloc<ClientMapSeekerEvent, ClientMapSeekerState> {
  GeolocatorUseCases geolocatorUseCases;
  SocketUseCases socketUseCases;

  ClientMapSeekerBloc(this.geolocatorUseCases, this.socketUseCases)
      : super(ClientMapSeekerState()) {
    on<ClientMapSeekerInitEvent>((event, emit) {
      Completer<GoogleMapController> controller = Completer<GoogleMapController>();
      emit(state.copyWith(controller: controller));
    });

    on<FindPosition>((event, emit) async {
      Position position = await geolocatorUseCases.findPosition.run();
      add(ChangeMapCameraPosition(lat: position.latitude, lng: position.longitude));
      emit(state.copyWith(
        position: position,
        /* BitmapDescriptor imageMarker =
        markers: {marker.markerId: marker},*/
      ));
      print('Position Lat: ${position.latitude}');
      print('Position Lng: ${position.longitude}');
    });

    on<ChangeMapCameraPosition>((event, emit) async {
      GoogleMapController googleMapController = await state.controller!.future;
      await googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(event.lat, event.lng), zoom: 13, bearing: 0)));
    });

    on<OnCameraMove>((event, emit) {
      emit(state.copyWith(cameraPosition: event.cameraPosition));
    });

    on<OnCameraIdle>((event, emit) async {
      PlacemarkData placemarkData =
          await geolocatorUseCases.getPlacemarkdata.run(state.cameraPosition);
      emit(state.copyWith(placemarkData: placemarkData));
    });

    on<OnAutoCompletedPickUpSelected>((event, emit) {
      emit(state.copyWith(
          pickUpLatLng: LatLng(event.lat, event.lng),
          pickUpDescription: event.pickUpDescription));
    });

    on<OnAutoCompletedDestinationSelected>((event, emit) {
      emit(state.copyWith(
          destinationLatlng: LatLng(event.lat, event.lng),
          destinationDescription: event.destinationDescription));
    });

    on<ConnectSocketIO>((event, emit) {
      Socket socket = socketUseCases.connect.run();
      emit(state.copyWith(socket: socket));
      add(ListenDriversPositionSocketIO());
    });

    on<DisconnectSocketIO>((event, emit) {
      Socket socket = socketUseCases.disconnect.run();
      emit(state.copyWith(socket: socket));
    });

    on<ListenDriversPositionSocketIO>((event, emit) {
      state.socket?.on('new_driver_position', (data) {
        print('DATOS DE SOCKET IO');
        print('Id: ${data['id']}');
        print('Lat: ${data['lat']}');
        print('Lng: ${data['lng']}');
      });
    });
  }
}
