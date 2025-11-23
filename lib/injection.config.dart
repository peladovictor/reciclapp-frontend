// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_application_1/src/data/dataSource/local/SharefPref.dart'
    as _i1047;
import 'package:flutter_application_1/src/data/dataSource/remote/services/AuthService.dart'
    as _i301;
import 'package:flutter_application_1/src/data/dataSource/remote/services/UsersService.dart'
    as _i994;
import 'package:flutter_application_1/src/di/AppModule.dart' as _i903;
import 'package:flutter_application_1/src/domain/repository/AuthRepository.dart'
    as _i200;
import 'package:flutter_application_1/src/domain/repository/GeolocatorRespository.dart'
    as _i971;
import 'package:flutter_application_1/src/domain/repository/SocketRepository.dart'
    as _i735;
import 'package:flutter_application_1/src/domain/repository/UsersRepository.dart'
    as _i860;
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCase.dart'
    as _i62;
import 'package:flutter_application_1/src/domain/useCases/geolocator/GeolocatorUseCases.dart'
    as _i936;
import 'package:flutter_application_1/src/domain/useCases/socket/SocketUseCases.dart'
    as _i329;
import 'package:flutter_application_1/src/domain/useCases/users/UsersUseCases.dart'
    as _i548;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:socket_io_client/socket_io_client.dart' as _i414;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i1047.SharefPref>(() => appModule.sharefPref);
    gh.factory<_i414.Socket>(() => appModule.socket);
    gh.factoryAsync<String>(() => appModule.token);
    gh.factory<_i301.AuthService>(() => appModule.authService);
    gh.factory<_i994.UsersService>(() => appModule.usersService);
    gh.factory<_i200.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i860.UsersRepository>(() => appModule.usersRepository);
    gh.factory<_i735.SocketRepository>(() => appModule.socketRepository);
    gh.factory<_i971.GeolocatorRespository>(
        () => appModule.geolocatorRespository);
    gh.factory<_i62.AuthUseCases>(() => appModule.authUseCases);
    gh.factory<_i548.UsersUseCases>(() => appModule.usersUseCases);
    gh.factory<_i936.GeolocatorUseCases>(() => appModule.geolocatorUseCases);
    gh.factory<_i329.SocketUseCases>(() => appModule.socketUseCases);
    return this;
  }
}

class _$AppModule extends _i903.AppModule {}
