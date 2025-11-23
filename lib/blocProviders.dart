import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/socket/SocketUseCases.dart';
import 'package:flutter_application_1/src/domain/useCases/users/UsersUseCases.dart';
import 'package:flutter_application_1/src/presentation/page/client/home/bloc/ClientHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapBokingInfo/bloc/ClientMapBookingInfoBloc.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapSeeker/bloc/ClientMapSeekerBloc.dart';
import 'package:flutter_application_1/src/presentation/page/driver/home/bloc/DriverHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/page/driver/mapLocation/bloc/DriverMapLocationBloc.dart';
import 'package:flutter_application_1/src/presentation/page/profile/info/bloc/ProfileInfoBloc.dart';
import 'package:flutter_application_1/src/presentation/page/profile/info/bloc/ProfileInfoEvent.dart';
import 'package:flutter_application_1/src/presentation/page/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:flutter_application_1/src/presentation/page/roles/bloc/RolesBloc.dart';
import 'package:flutter_application_1/src/presentation/page/roles/bloc/RolesEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/injection.dart';
import 'package:flutter_application_1/src/presentation/page/auth/login/bloc/LoginBloc.dart';
import 'package:flutter_application_1/src/presentation/page/auth/login/bloc/LoginEvent.dart';
import 'package:flutter_application_1/src/presentation/page/auth/register/bloc/RegisterBloc.dart';
import 'package:flutter_application_1/src/presentation/page/auth/register/bloc/RegisterEvent.dart';

List<BlocProvider> blocProvider = [
  BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(locator<AuthUseCases>())..add(LogiInitEvent())),
  BlocProvider<RegisterBloc>(
      create: (context) =>
          RegisterBloc(locator<AuthUseCases>())..add(RegisterInitEvent())),
  BlocProvider<ClientHomeBloc>(
      create: (context) => ClientHomeBloc(locator<AuthUseCases>())),
  BlocProvider<DriverHomeBloc>(
      create: (context) => DriverHomeBloc(locator<AuthUseCases>())),
  BlocProvider<RolesBloc>(
      create: (context) => RolesBloc(locator<AuthUseCases>())..add(GetRolesList())),
  BlocProvider<ProfileInfoBloc>(
      create: (context) => ProfileInfoBloc(locator<AuthUseCases>())..add(GetUserInfo())),
  BlocProvider<ProfileUpdateBloc>(
      create: (context) =>
          ProfileUpdateBloc(locator<UsersUseCases>(), locator<AuthUseCases>())),
  BlocProvider<ClientMapSeekerBloc>(
      create: (context) => ClientMapSeekerBloc(locator<GeolocatorUseCases>())),
  BlocProvider<ClientMapBookingInfoBloc>(
      create: (context) => ClientMapBookingInfoBloc(locator<GeolocatorUseCases>())),
  BlocProvider<DriverMapLocationBloc>(
      create: (context) => DriverMapLocationBloc(
          locator<GeolocatorUseCases>(), locator<SocketUseCases>())),
];
