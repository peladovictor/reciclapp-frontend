import 'package:flutter_application_1/src/domain/models/PlacemarkData.dart';
import 'package:flutter_application_1/src/domain/repository/GeolocatorRespository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetPlacemarkDataUsesCase {
  GeolocatorRespository geolocatorRespository;

  GetPlacemarkDataUsesCase(this.geolocatorRespository);

  run(CameraPosition cameraPosition) =>
      geolocatorRespository.getPlacemarkData(cameraPosition);
}
