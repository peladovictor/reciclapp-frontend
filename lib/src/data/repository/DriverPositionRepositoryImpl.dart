import 'package:flutter_application_1/src/data/dataSource/remote/services/DriversPositionService.dart';
import 'package:flutter_application_1/src/domain/models/DriverPosition.dart';
import 'package:flutter_application_1/src/domain/repository/DriverPositionRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

class DriverPositionRepositoryImpl implements DriverPositionRepository {
  DriversPositionService driversPositionService;

  DriverPositionRepositoryImpl(this.driversPositionService);

  @override
  Future<Resource<bool>> create(DriverPosition driverPosition) {
    return driversPositionService.create(driverPosition);
  }

  @override
  Future<Resource<bool>> delete(int idDriver) {
    return driversPositionService.delete(idDriver);
  }
}
