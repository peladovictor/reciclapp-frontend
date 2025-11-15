import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/src/domain/utils/ListToString.dart';
import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/domain/models/user.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class UsersService {
  Future<String> token;

  UsersService(this.token);

  Future<Resource<User>> update(int id, User user) async {
    try {
      // URL según tu ApiConfig
      final url = ApiConfig.uri('/users/$id');

      final auth = await token;

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': auth, // aquí va "Bearer xxx" si tu token ya lo trae
      };

      final bodyMap = {
        'name': user.name,
        'lastname': user.lastname,
        'phone': user.phone,
      };
      String body = json.encode(bodyMap);

      // 👇 DEBUG
      print('=== HTTP UPDATE USER ===');
      print('URL     => $url');
      print('HEADERS => $headers');
      print('BODY    => $body');

      final response = await http.put(url, headers: headers, body: body);

      print('STATUS  => ${response.statusCode}');
      print('RESPONSE BODY => ${response.body}');

      final decoded = response.body.isNotEmpty ? json.decode(response.body) : null;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // el backend puede devolver {message, data:{...}} o directamente el user
        dynamic userJson = decoded;
        if (decoded is Map && decoded['data'] != null) {
          userJson = decoded['data'];
        }

        User userResponse = User.fromJson(userJson);
        return Success<User>(userResponse);
      } else {
        String errorMessage = 'Error al actualizar usuario';

        if (decoded is Map && decoded['message'] != null) {
          if (decoded['message'] is List) {
            // si el backend manda una lista de errores
            errorMessage = listToString(List<String>.from(decoded['message'] as List));
          } else {
            errorMessage = decoded['message'].toString();
          }
        }

        return ErrorData<User>(errorMessage);
      }
    } catch (e) {
      print('EXCEPTION UPDATE USER => $e');
      return ErrorData<User>('Error de red al actualizar usuario');
    }
  }

  Future<Resource<User>> updateImage(int id, User user, File file) async {
    try {
      final url = ApiConfig.uri('/users/upload/$id');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = await token;
      request.files.add(http.MultipartFile(
          'file', http.ByteStream(file.openRead().cast()), await file.length(),
          filename: basename(file.path), contentType: MediaType('image', 'jpg')));
      request.fields['name'] = user.name;
      request.fields['lastname'] = user.lastname;
      request.fields['phone'] = user.phone;
      final response = await request.send();
      final data = json.decode(await response.stream.transform(utf8.decoder).first);
      if (response.statusCode == 200 || response.statusCode == 201) {
        User userResponse = User.fromJson(data);
        print("Success: ${data}");
        return Success(userResponse);
      } else {
        print("Error: ${response.statusCode} - ${data['message']}");
        return ErrorData(listToString(['message']));
      }
    } catch (e) {
      print('Error: $e');
      return ErrorData(e.toString());
    }
  }
}
