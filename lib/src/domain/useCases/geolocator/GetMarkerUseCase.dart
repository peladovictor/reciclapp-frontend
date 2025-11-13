import 'package:flutter_application_1/src/domain/repository/GeolocatorRespository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetMarkerUseCase {
  GeolocatorRespository geolocatorRespository;
  GetMarkerUseCase(this.geolocatorRespository);
  run(String markerId, double lat, double lng, String title,
          String content, BitmapDescriptor imageMarker) =>
      geolocatorRespository.getMarker(
          markerId, lat, lng, title, content, imageMarker);
}
