import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocProviders.dart';
import 'package:flutter_application_1/injection.dart';
import 'package:flutter_application_1/src/presentation/page/auth/register/RegisterPage.dart';
import 'package:flutter_application_1/src/presentation/page/client/home/ClientHomePage.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapBokingInfo/ClientMapBookingInfoPage.dart';
import 'package:flutter_application_1/src/presentation/page/driver/home/DriverHomePage.dart';
import 'package:flutter_application_1/src/presentation/page/profile/update/ProfileUpdatePage.dart';
import 'package:flutter_application_1/src/presentation/page/roles/RolesPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/presentation/page/auth/login/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(); // inyecta los repositorios, blocs, etc.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProvider, // se cargan todos los blocs definidos
      child: MaterialApp(
        builder: FToashtBuilder(),
        title: 'ReciclaAPP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color.fromRGBO(103, 58, 183, 1)),
          useMaterial3: true,
        ),
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'register': (BuildContext context) => RegisterPage(),
          'roles': (BuildContext context) => RolesPage(),
          'client/home': (BuildContext context) => ClientHomePage(),
          'driver/home': (BuildContext context) => DriverHomePage(),
          'client/map/booking': (BuildContext context) => ClientMapBookingInfoPage(),
          'profile/update': (BuildContext context) => ProfileUpdatePage(),
        },
      ),
    );
  }

  FToashtBuilder() {}
}
