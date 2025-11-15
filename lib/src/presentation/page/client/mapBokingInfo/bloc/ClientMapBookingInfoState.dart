import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapBookingInfoState extends Equatable {
  final Completer<GoogleMapController>? controller;
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines;
  final LatLng? pickUpLatLng;
  final LatLng? destinationLatlng;
  final String pickUpDescription;
  final String destinationDescription;

  ClientMapBookingInfoState(
      {this.position,
      this.controller,
      this.cameraPosition =
          const CameraPosition(target: LatLng(-33.3992012, -70.6262937), zoom: 17.0),
      this.pickUpLatLng,
      this.destinationLatlng,
      this.pickUpDescription = '',
      this.destinationDescription = '',
      this.markers = const <MarkerId, Marker>{},
      this.polylines = const <PolylineId, Polyline>{}}); // 👈 AQUÍ EL CAMBIO

  ClientMapBookingInfoState copyWith(
      {Position? position,
      Completer<GoogleMapController>? controller,
      CameraPosition? cameraPosition,
      LatLng? pickUpLatLng,
      LatLng? destinationLatlng,
      String? pickUpDescription,
      String? destinationDescription,
      Map<MarkerId, Marker>? markers,
      Map<PolylineId, Polyline>? polylines}) {
    return ClientMapBookingInfoState(
      position: position ?? this.position,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      controller: controller ?? this.controller,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      pickUpLatLng: pickUpLatLng ?? this.pickUpLatLng,
      destinationLatlng: destinationLatlng ?? this.destinationLatlng,
      pickUpDescription: pickUpDescription ?? this.pickUpDescription,
      destinationDescription: destinationDescription ?? this.destinationDescription,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        position,
        markers,
        polylines,
        controller,
        cameraPosition,
        pickUpLatLng,
        destinationLatlng,
        pickUpDescription,
        destinationDescription
      ];
}
