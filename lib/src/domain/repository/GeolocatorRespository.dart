import 'package:flutter_application_1/src/domain/models/PlacemarkData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GeolocatorRespository {
  Future<Position> findPosition();
  Future<BitmapDescriptor> createMarkerFromAsset(String path);
  Marker getMarker(String markerId, double lat, double lng, String title, String content,
      BitmapDescriptor imageMarker);
  Future<PlacemarkData?> getPlacemarkData(CameraPosition cameraposition);
  Future<List<LatLng>> getPolyline(LatLng pickUpLatLng, LatLng destinationLatLng);
  Stream<Position> getPositionStream();
}
