import 'package:flutter_application_1/src/domain/repository/GeolocatorRespository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetPolylineUseCase {
  GeolocatorRespository geolocatorRespository;

  GetPolylineUseCase(this.geolocatorRespository);

  run(LatLng pickUpLatlng, LatLng destinationLatLng) =>
      geolocatorRespository.getPolyline(pickUpLatlng, destinationLatLng);
}
