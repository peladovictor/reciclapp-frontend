import 'package:flutter_application_1/src/domain/models/user.dart';
import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';

class RegisterUseCase {
  AuthRepository authRepository;
  RegisterUseCase(this.authRepository);
  run(User user) => authRepository.register(user);
}
