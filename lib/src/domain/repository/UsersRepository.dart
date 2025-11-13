import 'dart:io';

import 'package:flutter_application_1/src/domain/models/user.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

abstract class UsersRepository {
  Future<Resource<User>> update(int id, User user, File? file);
}
