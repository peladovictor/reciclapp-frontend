import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';

class LogoutUsecase {
  AuthRepository authRepository;

  LogoutUsecase(this.authRepository);

  run() => authRepository.logout();
}
