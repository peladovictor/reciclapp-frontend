import 'package:flutter_application_1/src/domain/repository/DriverPositionRepository.dart';

class DeleteDriverPositionUseCase {
  DriverPositionRepository driverPositionRepository;

  DeleteDriverPositionUseCase(this.driverPositionRepository);

  run(int idDriver) => driverPositionRepository.delete(idDriver);
}
