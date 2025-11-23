import 'package:geolocator/geolocator.dart';
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

class UpdateLocation extends DriverMapLocationEvent {
  final Position position;

  UpdateLocation({required this.position});
}

class StopLocation extends DriverMapLocationEvent {}

class AddMyPositionMarker extends DriverMapLocationEvent {
  final double lat;
  final double lng;
  AddMyPositionMarker({required this.lat, required this.lng});
}

class ConnectSocketIO extends DriverMapLocationEvent {}

class DisconnectSocketIO extends DriverMapLocationEvent {}

class EmitDriverPositionSocketIO extends DriverMapLocationEvent {}

class EmiDriverPositionSocketIO extends DriverMapLocationEvent {}
