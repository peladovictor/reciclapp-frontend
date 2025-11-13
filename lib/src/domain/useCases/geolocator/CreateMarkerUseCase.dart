import 'package:flutter_application_1/src/domain/repository/GeolocatorRespository.dart';

class CreateMarkerUseCase {
  GeolocatorRespository geolocatorRespository;
  CreateMarkerUseCase(this.geolocatorRespository);

  run(String path) =>
      geolocatorRespository.createMarkerFromAsset(path);
}
