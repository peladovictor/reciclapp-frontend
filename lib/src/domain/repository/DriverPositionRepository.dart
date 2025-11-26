import 'package:flutter_application_1/src/domain/models/DriverPosition.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

abstract class DriverPositionRepository {
  Future<Resource<bool>> create(DriverPosition driverPosition);
  Future<Resource<bool>> delete(int idDriver);
}
