import 'dart:io';

import 'package:flutter_application_1/src/domain/models/user.dart';
import 'package:flutter_application_1/src/domain/repository/UsersRepository.dart';

class UpdateUsersUseCase {
  UsersRepository usersRepository;
  UpdateUsersUseCase(this.usersRepository);
  run(int id, User user, File? file) => usersRepository.update(id, user, file);
}
