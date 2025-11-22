import 'package:flutter_application_1/src/domain/repository/GeolocatorRespository.dart';

class GetPositionStreamUseCase {
  GeolocatorRespository geolocatorRespository;

  GetPositionStreamUseCase(this.geolocatorRespository);

  run() => geolocatorRespository.getPositionStream();
}
