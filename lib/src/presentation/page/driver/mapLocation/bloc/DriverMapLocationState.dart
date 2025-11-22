import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapLocationState extends Equatable {
  final Completer<GoogleMapController> controller; // 👈 YA NO ES NULABLE
  final Position? position;
  final CameraPosition cameraPosition;
  final Map<MarkerId, Marker> markers;

  DriverMapLocationState({
    Position? position,
    Completer<GoogleMapController>? controller,
    CameraPosition cameraPosition =
        const CameraPosition(target: LatLng(-33.3992012, -70.6262937), zoom: 17.0),
    Map<MarkerId, Marker> markers = const <MarkerId, Marker>{},
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
      markers: markers ?? this.markers,
      controller: controller ?? this.controller,
      cameraPosition: cameraPosition ?? this.cameraPosition,
    );
  }

  @override
  List<Object?> get props => [
        position,
        markers,
        controller,
        cameraPosition,
      ];
}
