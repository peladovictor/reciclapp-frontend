import 'package:flutter_application_1/src/data/api/ApiConfig.dart';
import 'package:flutter_application_1/src/data/dataSource/local/SharefPref.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/AuthService.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/DriversPositionService.dart';
import 'package:flutter_application_1/src/data/dataSource/remote/services/UsersService.dart';
import 'package:flutter_application_1/src/data/repository/AuthRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/repository/DriverPositionRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/repository/GeolocatorRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/repository/SocketRepositoryImpl.dart';
import 'package:flutter_application_1/src/data/repository/UsersRepositoryImpl.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart';
import 'package:flutter_application_1/src/domain/repository/DriverPositionRepository.dart';
import 'package:flutter_application_1/src/domain/repository/GeolocatorRespository.dart';
import 'package:flutter_application_1/src/domain/repository/SocketRepository.dart';
import 'package:flutter_application_1/src/domain/repository/UsersRepository.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/GetUserSessionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/LoginUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/LogoutUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/RegisterUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/SaveUserSessionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/driver-position/CreateDriverPositionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/driver-position/DeleteDriverPositionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/driver-position/DriversPositionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/CreateMarkerUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GetMarkerUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GetPlacemarkDataUsesCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GetPolylineUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GetPositionStreamUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/findPositionUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/socket/ConnectSocketUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/socket/DisconnectSocketUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/socket/SocketUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/users/UpdateUserUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/users/UsersUseCases.dart';
import 'package:injectable/injectable.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

@module
abstract class AppModule {
  @injectable
  SharefPref get sharefPref => SharefPref();

  // 👇 Socket conectado a la misma baseUrl del backend (local o nube)
  @injectable
  IO.Socket get socket => IO.io(
        ApiConfig.baseUrl, // Ej: http://10.0.2.2:3000 o https://proyecto...
        IO.OptionBuilder()
            .setTransports(['websocket']) // en minúscula
            .disableAutoConnect() // lo conectamos desde el bloc
            .build(),
      );

  @injectable
  Future<String> get token async {
    String token = '';
    final userSession = await sharefPref.read('user');
    if (userSession != null) {
      final authResponse = AuthResponse.fromJson(userSession);
      token = authResponse.token;
    }
    return token;
  }

  @injectable
  AuthService get authService => AuthService();

  @injectable
  UsersService get usersService => UsersService(token);

  @injectable
  DriversPositionService get driversPositionService => DriversPositionService();

  @injectable
  AuthRepository get authRepository => AuthRepositoryImpl(authService, sharefPref);

  @injectable
  UsersRepository get usersRepository => UsersRepositoryImpl(usersService);

  @injectable
  SocketRepository get socketRepository => SocketRepositoryImpl(socket);

  @injectable
  GeolocatorRespository get geolocatorRespository => GeolocatorRepositoryImpl();

  @injectable
  DriverPositionRepository get driversPositionRepository =>
      DriverPositionRepositoryImpl(driversPositionService);

  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
        login: LoginUseCase(authRepository),
        register: RegisterUseCase(authRepository),
        saveUserSession: SaveUserSessionUseCase(authRepository),
        getUserSession: GetUserSessionUseCase(authRepository),
        logout: LogoutUsecase(authRepository),
      );

  @injectable
  UsersUseCases get usersUseCases =>
      UsersUseCases(update: UpdateUsersUseCase(usersRepository));

  @injectable
  GeolocatorUseCases get geolocatorUseCases => GeolocatorUseCases(
        findPosition: FindPositionUsecase(geolocatorRespository),
        createMarker: CreateMarkerUseCase(geolocatorRespository),
        getMarker: GetMarkerUseCase(geolocatorRespository),
        getPlacemarkdata: GetPlacemarkDataUsesCase(geolocatorRespository),
        getPolyline: GetPolylineUseCase(geolocatorRespository),
        getPositionStream: GetPositionStreamUseCase(geolocatorRespository),
      );

  @injectable
  SocketUseCases get socketUseCases => SocketUseCases(
        connect: ConnectSocketUseCase(socketRepository),
        disconnect: DisconnectSocketUseCase(socketRepository),
      );

  @injectable
  DriversPositionUseCase get driverPositionUseCase => DriversPositionUseCase(
        CreateDriverPositionUseCase(driversPositionRepository),
        DeleteDriverPositionUseCase(driversPositionRepository),
      );
}
