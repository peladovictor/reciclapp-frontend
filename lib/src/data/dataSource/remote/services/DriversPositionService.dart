import 'dart:convert';

import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/domain/models/DriverPosition.dart';
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;

class DriversPositionService {
  Future<Resource<bool>> create(DriverPosition driverPosition) async {
    try {
      // 👇 Igual que en AuthService: usamos el helper de ApiConfig
      final url = ApiConfig.uri('/drivers-position');

      final headers = {
        'Content-Type': 'application/json',
      };

      // Si tu modelo tiene toJson(), usa eso:
      final body = json.encode(driverPosition.toJson());
      // Si NO tiene toJson(), cambia la línea anterior por:
      // final body = json.encode(driverPosition);

      final response = await http.post(url, headers: headers, body: body);

      print('[DRIVERS_POSITION] status: ${response.statusCode}');
      print('[DRIVERS_POSITION] raw: ${response.body}');

      final data = response.body.isNotEmpty ? json.decode(response.body) : {};

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(true);
      } else {
        return ErrorData(listToString(data['message'] ?? data));
      }
    } catch (e) {
      print('[DRIVERS_POSITION] catch: $e');
      return ErrorData(e.toString());
    }
  }

  Future<Resource<bool>> delete(int idDriver) async {
    try {
      // 👇 Igual que en AuthService: usamos el helper de ApiConfig
      final url = ApiConfig.uri('/drivers-position/${idDriver}');

      final headers = {
        'Content-Type': 'application/json',
      };

      final response = await http.delete(url, headers: headers);

      print('[DRIVERS_POSITION] status: ${response.statusCode}');
      print('[DRIVERS_POSITION] raw: ${response.body}');

      final data = response.body.isNotEmpty ? json.decode(response.body) : {};

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(true);
      } else {
        return ErrorData(listToString(data['message'] ?? data));
      }
    } catch (e) {
      print('[DRIVERS_POSITION] catch: $e');
      return ErrorData(e.toString());
    }
  }
}
