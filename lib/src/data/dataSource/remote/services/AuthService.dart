import 'dart:convert';

import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/models/user.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Resource<AuthResponse>> login(String email, String password) async {
    try {
      // 👇 ahora usamos la URL completa (http local / https nube)
      final url = ApiConfig.uri('/auth/login');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({'email': email, 'password': password});

      final response = await http.post(url, headers: headers, body: body);
      print('[LOGIN] status: ${response.statusCode}');
      print('[LOGIN] raw: ${response.body}');

      final data = response.body.isNotEmpty ? json.decode(response.body) : {};
      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(data);
        print('[LOGIN] parsed: ${authResponse.toJson()}');
        return Success(authResponse);
      } else {
        // si message no existe, caer al body entero
        return ErrorData(listToString(data['message'] ?? data));
      }
    } catch (e) {
      print('[LOGIN] catch: $e');
      return ErrorData(e.toString());
    }
  }

  Future<Resource<AuthResponse>> register(User user) async {
    try {
      // 👇 igual aquí
      final url = ApiConfig.uri('/auth/register');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode(user.toJson());

      final response = await http.post(url, headers: headers, body: body);
      print('[REGISTER] status: ${response.statusCode}');
      print('[REGISTER] raw: ${response.body}');

      final data = response.body.isNotEmpty ? json.decode(response.body) : {};
      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(data);
        print('[REGISTER] parsed: ${authResponse.toJson()}');
        return Success(authResponse);
      } else {
        return ErrorData(listToString(data['message'] ?? data));
      }
    } catch (e) {
      print('[REGISTER] catch: $e');
      return ErrorData(e.toString());
    }
  }
}
