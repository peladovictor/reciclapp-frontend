import 'package:flutter_application_1/src/domain/models/DriverPosition.dart';
import 'package:flutter_application_1/src/domain/repository/DriverPositionRepository.dart';

class CreateDriverPositionUseCase {
  DriverPositionRepository driverPositionRepository;

  CreateDriverPositionUseCase(this.driverPositionRepository);

  run(DriverPosition driverPosition) => driverPositionRepository.create(driverPosition);
}
