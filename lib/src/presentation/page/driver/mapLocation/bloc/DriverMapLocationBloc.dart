import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/socket/SocketUseCases.dart';
import 'package:flutter_application_1/src/presentation/page/driver/mapLocation/bloc/DriverMapLocationEvent.dart';
import 'package:flutter_application_1/src/presentation/page/driver/mapLocation/bloc/DriverMapLocationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapLocationBloc extends Bloc<DriverMapLocationEvent, DriverMapLocationState> {
  SocketUseCases socketUseCases;
  GeolocatorUseCases geolocatorUseCases;
  AuthUseCases authUseCases;
  StreamSubscription? positionSubscription;

  DriverMapLocationBloc(this.geolocatorUseCases, this.socketUseCases, this.authUseCases)
      : super(DriverMapLocationState()) {
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
    });

    on<AddMyPositionMarker>((event, emit) async {
      print('[DRIVER] AddMyPositionMarker -> lat: ${event.lat}, lng: ${event.lng}');

      BitmapDescriptor descriptor;
      try {
        // Intentamos usar tu pin personalizado
        descriptor = await geolocatorUseCases.createMarker.run('assets/img/car_pin2.png');
      } catch (e) {
        // Si en iOS pasa algo con el asset, al menos usamos un marker por defecto
        print('[DRIVER] Error creando descriptor car_pin2.png: $e');
        descriptor = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        );
      }

      // Id único del marker del driver
      final markerId = const MarkerId('my_location');

      final marker = geolocatorUseCases.getMarker.run(
        'my_location',
        event.lat,
        event.lng,
        'Mi posición',
        '',
        descriptor,
      );

      // Clonamos el mapa actual de markers y actualizamos solo el del driver
      final updatedMarkers = Map<MarkerId, Marker>.from(state.markers);
      updatedMarkers[markerId] = marker;

      emit(state.copyWith(markers: updatedMarkers));

      print('[DRIVER] markers ahora: ${updatedMarkers.length}');
    });

    on<ChangeMapCameraPosition>((event, emit) async {
      final mapController = state.controller;

      // Si el controller todavía es null o no está listo, salimos sin hacer nada
      if (mapController == null || !mapController.isCompleted) {
        return;
      }

      final googleMapController = await mapController.future;
      await googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.lat, event.lng),
            zoom: 13,
            bearing: 0,
          ),
        ),
      );
    });

    on<UpdateLocation>((event, emit) async {
      add(AddMyPositionMarker(
          lat: event.position.latitude, lng: event.position.longitude));
      add(ChangeMapCameraPosition(
          lat: event.position.latitude, lng: event.position.longitude));
      emit(state.copyWith(position: event.position));
      add(EmitDriverPositionSocketIO());
    });

    on<StopLocation>((event, emit) {
      positionSubscription?.cancel();
    });

    on<ConnectSocketIO>((event, emit) {
      Socket socket = socketUseCases.connect.run();
      emit(state.copyWith(socket: socket));
    });

    on<DisconnectSocketIO>((event, emit) {
      Socket socket = socketUseCases.disconnect.run();
      emit(state.copyWith(socket: socket));
    });

    on<EmitDriverPositionSocketIO>((event, emit) async {
      AuthResponse authResponse = await authUseCases.getUserSession.run();
      state.socket?.emit('change_driver_position', {
        'id': authResponse.user.id,
        'lat': state.position!.latitude,
        'lng': state.position!.longitude,
      });
    });
  }
}
