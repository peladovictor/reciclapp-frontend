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
      emit(state.copyWith(position: position));
    });

    on<ChangeMapCameraPosition>((event, emit) async {
      GoogleMapController googleMapController = await state.controller!.future;
      await googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(event.lat, event.lng), zoom: 13, bearing: 0),
        ),
      );
    });

    on<OnCameraMove>((event, emit) {
      emit(state.copyWith(cameraPosition: event.cameraPosition));
    });

    on<OnCameraIdle>((event, emit) async {
      PlacemarkData placemarkData = await geolocatorUseCases.getPlacemarkdata.run(
        state.cameraPosition,
      );
      emit(state.copyWith(placemarkData: placemarkData));
    });

    on<OnAutoCompletedPickUpSelected>((event, emit) {
      emit(
        state.copyWith(
          pickUpLatLng: LatLng(event.lat, event.lng),
          pickUpDescription: event.pickUpDescription,
        ),
      );
    });

    on<OnAutoCompletedDestinationSelected>((event, emit) {
      emit(
        state.copyWith(
          destinationLatlng: LatLng(event.lat, event.lng),
          destinationDescription: event.destinationDescription,
        ),
      );
    });

    on<ConnectSocketIO>((event, emit) {
      final Socket socket = socketUseCases.connect.run();

      print('[SOCKET CLIENTE] creado. connected?: ${socket.connected}');

      socket.onConnect((_) {
        print('[SOCKET CLIENTE] onConnect -> id: ${socket.id}');
      });

      socket.onConnectError((data) {
        print('[SOCKET CLIENTE] onConnectError: $data');
      });

      socket.onError((data) {
        print('[SOCKET CLIENTE] onError: $data');
      });

      socket.onDisconnect((_) {
        print('[SOCKET CLIENTE] onDisconnect');
      });

      emit(state.copyWith(socket: socket));

      // Después de tener el socket en el estado, me suscribo
      add(ListenDriversPositionSocketIO());
      add(ListenDriversDisconnectedSocketIO());
    });

    on<DisconnectSocketIO>((event, emit) {
      Socket socket = socketUseCases.disconnect.run();
      emit(state.copyWith(socket: socket));
    });

    on<ListenDriversPositionSocketIO>((event, emit) async {
      final socket = state.socket;

      if (socket == null) {
        print('[SOCKET CLIENTE] socket es null en ListenDriversPositionSocketIO');
        return;
      }

      print('[SOCKET CLIENTE] Me voy a suscribir a new_driver_position');

      // Limpio listeners antiguos para evitar duplicados
      socket.off('new_driver_position');

      socket.on('new_driver_position', (data) {
        print('========== DATOS DE SOCKET IO ==========');
        print('Id socket: ${data['id_socket']}');
        print('Id usuario: ${data['id']}');
        print('Lat: ${data['lat']}');
        print('Lng: ${data['lng']}');
        print('========================================');

        // Conversión segura de num -> double
        final num? latNum = data['lat'] as num?;
        final num? lngNum = data['lng'] as num?;

        if (latNum == null || lngNum == null) {
          print('[SOCKET CLIENTE] lat/lng nulos, no se dibuja marker');
          return;
        }

        final double lat = latNum.toDouble();
        final double lng = lngNum.toDouble();

        add(
          AddDriverPositionMarker(
            idSocket: data['id_socket']?.toString() ?? '',
            id: (data['id'] as num?)?.toInt() ?? 0,
            lat: lat,
            lng: lng,
          ),
        );
      });
    });

    on<ListenDriversDisconnectedSocketIO>((event, emit) {
      final socket = state.socket;

      if (socket == null) {
        print('[SOCKET CLIENTE] socket es null en ListenDriversDisconnectedSocketIO');
        return;
      }

      socket.off('driver_disconnected');

      socket.on('driver_disconnected', (data) {
        print('[SOCKET CLIENTE] driver_disconnected -> ${data['id_socket']}');
        add(RemoveDriverPositionMarker(idSocket: data['id_socket'] as String));
      });
    });

    on<RemoveDriverPositionMarker>((event, emit) {
      final markerId = MarkerId('driver_${event.idSocket}');
      emit(
        state.copyWith(
          markers: Map.of(state.markers)..remove(markerId),
        ),
      );
    });

    on<AddDriverPositionMarker>((event, emit) async {
      print('[BLOC CLIENTE] AddDriverPositionMarker -> '
          'idSocket: ${event.idSocket}, lat: ${event.lat}, lng: ${event.lng}');

      final BitmapDescriptor descriptor =
          await geolocatorUseCases.createMarker.run('assets/img/car_pin2.png');

      final Marker marker = geolocatorUseCases.getMarker.run(
        event.idSocket, // MarkerId = id del socket del driver
        event.lat,
        event.lng,
        'Conductor disponible',
        '',
        descriptor,
      );

      final updatedMarkers = Map<MarkerId, Marker>.from(state.markers);
      updatedMarkers[marker.markerId] = marker;

      emit(state.copyWith(markers: updatedMarkers));

      print('[BLOC CLIENTE] markers ahora: ${updatedMarkers.length}');
    });
  }
}
