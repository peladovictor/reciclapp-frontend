import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/src/domain/models/PlacemarkData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapSeekerState extends Equatable {
  final Completer<GoogleMapController>? controller;
  final Position? position;
  final CameraPosition cameraPosition;
  final PlacemarkData? placemarkData;
  final Map<MarkerId, Marker> markers;
  final LatLng? pickUpLatLng;
  final LatLng? destinationLatlng;
  final String pickUpDescription;
  final String destinationDescription;

  ClientMapSeekerState(
      {this.position,
      this.controller,
      this.cameraPosition = const CameraPosition(
          target: LatLng(-33.3992012, -70.6262937), zoom: 17.0),
      this.placemarkData,
      this.pickUpLatLng,
      this.destinationLatlng,
      this.pickUpDescription = '',
      this.destinationDescription = '',
      this.markers = const <MarkerId, Marker>{}});

  ClientMapSeekerState copyWith(
      {Position? position,
      Completer<GoogleMapController>? controller,
      CameraPosition? cameraPosition,
      PlacemarkData? placemarkData,
      LatLng? pickUpLatLng,
      LatLng? destinationLatlng,
      String? pickUpDescription,
      String? destinationDescription,
      Map<MarkerId, Marker>? markers}) {
    return ClientMapSeekerState(
      position: position ?? this.position,
      markers: markers ?? this.markers,
      controller: controller ?? this.controller,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      placemarkData: placemarkData ?? this.placemarkData,
      pickUpLatLng: pickUpLatLng ?? this.pickUpLatLng,
      destinationLatlng: destinationLatlng ?? this.destinationLatlng,
      pickUpDescription: pickUpDescription ?? this.pickUpDescription,
      destinationDescription:
          destinationDescription ?? this.destinationDescription,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        position,
        markers,
        controller,
        cameraPosition,
        placemarkData,
        pickUpLatLng,
        destinationLatlng,
        pickUpDescription,
        destinationDescription
      ];
}
