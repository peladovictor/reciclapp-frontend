import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapLocationState extends Equatable {
  final Completer<GoogleMapController> controller; // 👈 YA NO ES NULABLE
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;
  final LatLng? pickUpLatLng;
  final LatLng? destinationLatlng;
  final String pickUpDescription;
  final String destinationDescription;

  DriverMapLocationState({
    Position? position,
    Completer<GoogleMapController>? controller,
    CameraPosition cameraPosition =
        const CameraPosition(target: LatLng(-33.3992012, -70.6262937), zoom: 17.0),
    Map<MarkerId, Marker> markers = const <MarkerId, Marker>{},
    this.pickUpLatLng,
    this.destinationLatlng,
    this.pickUpDescription = '',
    this.destinationDescription = '',
  })  : position = position,
        controller = controller ?? Completer<GoogleMapController>(), // 👈 SIEMPRE HAY UNO
        cameraPosition = cameraPosition,
        markers = markers;

  DriverMapLocationState copyWith({
    Position? position,
    Completer<GoogleMapController>? controller,
    CameraPosition? cameraPosition,
    Map<MarkerId, Marker>? markers,
    LatLng? pickUpLatLng,
    LatLng? destinationLatlng,
    String? pickUpDescription,
    String? destinationDescription,
  }) {
    return DriverMapLocationState(
      position: position ?? this.position,
      controller: controller ?? this.controller,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      markers: markers ?? this.markers,
      pickUpLatLng: pickUpLatLng ?? this.pickUpLatLng,
      destinationLatlng: destinationLatlng ?? this.destinationLatlng,
      pickUpDescription: pickUpDescription ?? this.pickUpDescription,
      destinationDescription: destinationDescription ?? this.destinationDescription,
    );
  }

  @override
  List<Object?> get props => [
        position,
        controller,
        cameraPosition,
        markers,
        pickUpLatLng,
        destinationLatlng,
        pickUpDescription,
        destinationDescription,
      ];
}
