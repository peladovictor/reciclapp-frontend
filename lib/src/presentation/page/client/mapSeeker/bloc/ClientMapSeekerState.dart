import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/models/PlacemarkData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapSeekerState extends Equatable {
  final Completer<GoogleMapController> controller;
  final Position? position;
  final CameraPosition cameraPosition;
  final PlacemarkData? placemarkData;
  final Map<MarkerId, Marker> markers;
  final LatLng? pickUpLatLng;
  final LatLng? destinationLatlng;
  final String pickUpDescription;
  final String destinationDescription;

  ClientMapSeekerState({
    Position? position,
    Completer<GoogleMapController>? controller,
    CameraPosition cameraPosition =
        const CameraPosition(target: LatLng(-33.3992012, -70.6262937), zoom: 17.0),
    PlacemarkData? placemarkData,
    LatLng? pickUpLatLng,
    LatLng? destinationLatlng,
    String pickUpDescription = '',
    String destinationDescription = '',
    Map<MarkerId, Marker> markers = const <MarkerId, Marker>{},
  })  : position = position,
        controller = controller ?? Completer<GoogleMapController>(),
        cameraPosition = cameraPosition,
        placemarkData = placemarkData,
        pickUpLatLng = pickUpLatLng,
        destinationLatlng = destinationLatlng,
        pickUpDescription = pickUpDescription,
        destinationDescription = destinationDescription,
        markers = markers;

  ClientMapSeekerState copyWith({
    Position? position,
    Completer<GoogleMapController>? controller,
    CameraPosition? cameraPosition,
    PlacemarkData? placemarkData,
    LatLng? pickUpLatLng,
    LatLng? destinationLatlng,
    String? pickUpDescription,
    String? destinationDescription,
    Map<MarkerId, Marker>? markers,
  }) {
    return ClientMapSeekerState(
      position: position ?? this.position,
      controller: controller ?? this.controller,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      placemarkData: placemarkData ?? this.placemarkData,
      pickUpLatLng: pickUpLatLng ?? this.pickUpLatLng,
      destinationLatlng: destinationLatlng ?? this.destinationLatlng,
      pickUpDescription: pickUpDescription ?? this.pickUpDescription,
      destinationDescription: destinationDescription ?? this.destinationDescription,
      markers: markers ?? this.markers,
    );
  }

  @override
  List<Object?> get props => [
        position,
        markers,
        controller,
        cameraPosition,
        placemarkData,
        pickUpLatLng,
        destinationLatlng,
        pickUpDescription,
        destinationDescription,
      ];
}
