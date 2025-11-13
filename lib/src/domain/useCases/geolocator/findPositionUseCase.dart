import 'package:flutter_application_1/src/domain/repository/GeolocatorRespository.dart';

class FindPositionUsecase {
  GeolocatorRespository geolocatorRepository;
  FindPositionUsecase(this.geolocatorRepository);
  run() => geolocatorRepository.findPosition();
}
