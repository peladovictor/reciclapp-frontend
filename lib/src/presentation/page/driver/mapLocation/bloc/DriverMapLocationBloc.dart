import 'dart:async';

import 'package:flutter_application_1/src/domain/models/DriverPosition.dart';
import 'package:flutter_application_1/src/domain/useCases/driver-position/DriversPositionUseCase.dart';
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
  final SocketUseCases socketUseCases;
  final GeolocatorUseCases geolocatorUseCases;
  final AuthUseCases authUseCases;
  final DriversPositionUseCase driversPositionUseCase;
  StreamSubscription<Position>? positionSubscription;

  DriverMapLocationBloc(
    this.geolocatorUseCases,
    this.socketUseCases,
    this.authUseCases,
    this.driversPositionUseCase,
  ) : super(DriverMapLocationState()) {
    // 1) Init: guardar idDriver y controller del mapa
    on<DriverMapLocationInitEvent>((event, emit) async {
      final controller = Completer<GoogleMapController>();
      final AuthResponse authResponse = await authUseCases.getUserSession.run();

      emit(
        state.copyWith(
          controller: controller,
          idDriver: authResponse.user.id,
        ),
      );
    });

    // 2) Encontrar posición inicial y enganchar stream de ubicación
    on<FindPosition>((event, emit) async {
      final Position position = await geolocatorUseCases.findPosition.run();

      add(ChangeMapCameraPosition(lat: position.latitude, lng: position.longitude));
      add(AddMyPositionMarker(lat: position.latitude, lng: position.longitude));

      // Cancelar suscripción anterior si existe
      positionSubscription?.cancel();

      final Stream<Position> positionStream = geolocatorUseCases.getPositionStream.run();

      positionSubscription = positionStream.listen((Position position) {
        // Actualizamos UI y socket
        add(UpdateLocation(position: position));

        // Construimos el objeto para DB
        final driverPosition = DriverPosition(
          idDriver: state.idDriver!,
          lat: position.latitude,
          lng: position.longitude,
        );

        print('[BLOC] SaveLocationData stream -> ${driverPosition.toJson()}');

        // Disparamos evento para guardar en backend
        add(SaveLocationData(driverPosition: driverPosition));
      });

      emit(state.copyWith(position: position));
    });

    // 3) Agregar/actualizar marker del driver en el mapa
    on<AddMyPositionMarker>((event, emit) async {
      print('[DRIVER] AddMyPositionMarker -> lat: ${event.lat}, lng: ${event.lng}');

      BitmapDescriptor descriptor;
      try {
        descriptor = await geolocatorUseCases.createMarker.run('assets/img/car_pin2.png');
      } catch (e) {
        print('[DRIVER] Error creando descriptor car_pin2.png: $e');
        descriptor = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        );
      }

      const markerId = MarkerId('my_location');

      final marker = geolocatorUseCases.getMarker.run(
        'my_location',
        event.lat,
        event.lng,
        'Mi posición',
        '',
        descriptor,
      );

      final updatedMarkers = Map<MarkerId, Marker>.from(state.markers);
      updatedMarkers[markerId] = marker;

      emit(state.copyWith(markers: updatedMarkers));

      print('[DRIVER] markers ahora: ${updatedMarkers.length}');
    });

    // 4) Mover la cámara del mapa
    on<ChangeMapCameraPosition>((event, emit) async {
      final mapController = state.controller;

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

    // 5) UpdateLocation: actualiza marker, cámara, estado y socket
    on<UpdateLocation>((event, emit) async {
      add(AddMyPositionMarker(
          lat: event.position.latitude, lng: event.position.longitude));
      add(ChangeMapCameraPosition(
          lat: event.position.latitude, lng: event.position.longitude));

      emit(state.copyWith(position: event.position));

      add(EmitDriverPositionSocketIO());
    });

    // 6) StopLocation: detener stream y borrar registro en DB
    on<StopLocation>((event, emit) {
      positionSubscription?.cancel();
      positionSubscription = null;

      print('[BLOC] StopLocation -> idDriver=${state.idDriver}');
      add(DeleteLocationData(idDriver: state.idDriver!));
    });

    // 7) Conectar / desconectar socket
    on<ConnectSocketIO>((event, emit) {
      final Socket socket = socketUseCases.connect.run();
      emit(state.copyWith(socket: socket));
    });

    on<DisconnectSocketIO>((event, emit) {
      final Socket socket = socketUseCases.disconnect.run();
      emit(state.copyWith(socket: socket));
    });

    // 8) Emitir posición por socket (para el cliente)
    on<EmitDriverPositionSocketIO>((event, emit) async {
      if (state.position == null) return;

      state.socket?.emit('change_driver_position', {
        'id': state.idDriver,
        'lat': state.position!.latitude,
        'lng': state.position!.longitude,
      });
    });

    // 9) Guardar posición en backend (usa use case)
    on<SaveLocationData>((event, emit) async {
      print('[BLOC] SaveLocationData handler -> ${event.driverPosition.toJson()}');
      await driversPositionUseCase.createDriverPosition.run(event.driverPosition);
    });

    // 🔟 Eliminar posición en backend al detener
    on<DeleteLocationData>((event, emit) async {
      print('[BLOC] DeleteLocationData handler -> idDriver=${event.idDriver}');
      await driversPositionUseCase.deleteDriverPosition.run(event.idDriver);
    });
  }
}
