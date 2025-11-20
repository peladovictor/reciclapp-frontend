import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapBookingInfoState extends Equatable {
  final Completer<GoogleMapController> controller;
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines;
  final LatLng? pickUpLatLng;
  final LatLng? destinationLatlng;
  final String pickUpDescription;
  final String destinationDescription;

  ClientMapBookingInfoState({
    Position? position,
    Completer<GoogleMapController>? controller,
    CameraPosition cameraPosition =
        const CameraPosition(target: LatLng(-33.3992012, -70.6262937), zoom: 17.0),
    LatLng? pickUpLatLng,
    LatLng? destinationLatlng,
    String pickUpDescription = '',
    String destinationDescription = '',
    Map<MarkerId, Marker> markers = const <MarkerId, Marker>{},
    Map<PolylineId, Polyline> polylines = const <PolylineId, Polyline>{},
  })  : position = position,
        controller = controller ?? Completer<GoogleMapController>(),
        cameraPosition = cameraPosition,
        pickUpLatLng = pickUpLatLng,
        destinationLatlng = destinationLatlng,
        pickUpDescription = pickUpDescription,
        destinationDescription = destinationDescription,
        markers = markers,
        polylines = polylines;

  ClientMapBookingInfoState copyWith({
    Position? position,
    Completer<GoogleMapController>? controller,
    CameraPosition? cameraPosition,
    LatLng? pickUpLatLng,
    LatLng? destinationLatlng,
    String? pickUpDescription,
    String? destinationDescription,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polylines,
  }) {
    return ClientMapBookingInfoState(
      position: position ?? this.position,
      controller: controller ?? this.controller,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      pickUpLatLng: pickUpLatLng ?? this.pickUpLatLng,
      destinationLatlng: destinationLatlng ?? this.destinationLatlng,
      pickUpDescription: pickUpDescription ?? this.pickUpDescription,
      destinationDescription: destinationDescription ?? this.destinationDescription,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
    );
  }

  @override
  List<Object?> get props => [
        position,
        markers,
        polylines,
        controller,
        cameraPosition,
        pickUpLatLng,
        destinationLatlng,
        pickUpDescription,
        destinationDescription,
      ];
}
