import 'package:flutter_application_1/src/data/dataSource/local/SharefPref.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/models/user.dart';
import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';

import '../dataSource/remote/services/AuthService.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthService authService;
  SharefPref sharefPref;

  AuthRepositoryImpl(this.authService, this.sharefPref);

  @override
  Future<Resource<AuthResponse>> login(
      String email, String password) {
    return authService.login(email, password);
  }

  @override
  Future<Resource<AuthResponse>> register(User user) {
    return authService.register(user);
  }

  @override
  Future<AuthResponse?> getUserSession() async {
    final data = await sharefPref.read('user');
    if (data != null) {
      AuthResponse authResponse = AuthResponse.fromJson(data);
      return authResponse;
    }
    return null;
  }

  @override
  Future<void> saveUserSession(AuthResponse authResponse) async {
    await sharefPref.save('user', authResponse.toJson());
    final back = await sharefPref.read('user');
    print('[SESSION] verificada tras guardar: $back');
  }

  @override
  Future<bool> logout() async {
    return await sharefPref.remove('user');
  }
}
