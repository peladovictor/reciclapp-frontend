import 'dart:convert';

import 'package:flutter_application_1/src/domain/models/user.dart';

AuthResponse authResponseFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  final User user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] ?? const {}),
      token: (json['token'] ?? '').toString(), // <- evita null
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'token': token,
      };
}
