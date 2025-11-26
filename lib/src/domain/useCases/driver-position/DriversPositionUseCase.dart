import 'package:flutter_application_1/src/domain/useCases/driver-position/CreateDriverPositionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/driver-position/DeleteDriverPositionUseCase.dart';

class DriversPositionUseCase {
  // Campos internos
  final CreateDriverPositionUseCase createDriverPositionUseCase;
  final DeleteDriverPositionUseCase deleteDriverPositionUseCase;

  // 👇 Constructor con 2 parámetros POSICIONALES
  DriversPositionUseCase(
    this.createDriverPositionUseCase,
    this.deleteDriverPositionUseCase,
  );

  // 👇 Getters “bonitos” que usamos en el BLoC
  CreateDriverPositionUseCase get createDriverPosition => createDriverPositionUseCase;

  DeleteDriverPositionUseCase get deleteDriverPosition => deleteDriverPositionUseCase;
}
