import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/models/PlacemarkData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DriverMapLocationState extends Equatable {
  final Completer<GoogleMapController>? controller;
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;
  final Socket? socket;
  final int? idDriver;

  DriverMapLocationState(
      {this.position,
      this.controller,
      this.cameraPosition =
          const CameraPosition(target: LatLng(-33.3992012, -70.6262937), zoom: 17.0),
      this.markers = const <MarkerId, Marker>{},
      this.socket,
      this.idDriver});

  DriverMapLocationState copyWith(
      {Position? position,
      Completer<GoogleMapController>? controller,
      CameraPosition? cameraPosition,
      PlacemarkData? placemarkData,
      LatLng? pickUpLatLng,
      LatLng? destinationLatLng,
      String? pickUpDescription,
      String? destinationDescription,
      Map<MarkerId, Marker>? markers,
      Socket? socket,
      int? idDriver}) {
    return DriverMapLocationState(
        position: position ?? this.position,
        markers: markers ?? this.markers,
        controller: controller ?? this.controller,
        cameraPosition: cameraPosition ?? this.cameraPosition,
        socket: socket ?? this.socket,
        idDriver: idDriver ?? this.idDriver);
  }

  @override
  List<Object?> get props =>
      [position, markers, controller, cameraPosition, socket, idDriver];
}
