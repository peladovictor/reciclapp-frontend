import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class DriverMapLocationEvent {}

class DriverMapLocationInitEvent extends DriverMapLocationEvent {}

class FindPosition extends DriverMapLocationEvent {}

class ChangeMapCameraPosition extends DriverMapLocationEvent {
  final double lat;
  final double lng;

  ChangeMapCameraPosition({
    required this.lat,
    required this.lng,
  });
}

class OnCameraMove extends DriverMapLocationEvent {
  CameraPosition cameraPosition;

  OnCameraMove({required this.cameraPosition});
}
