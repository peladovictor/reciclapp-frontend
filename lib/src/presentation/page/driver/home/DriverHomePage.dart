import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapSeeker/ClientMapSeekerPage.dart';
import 'package:flutter_application_1/src/presentation/page/driver/home/bloc/DriverHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/page/driver/home/bloc/DriverHomeState.dart';
import 'package:flutter_application_1/src/presentation/page/driver/home/bloc/DriverHomeEvent.dart';
import 'package:flutter_application_1/src/presentation/page/profile/info/ProfileInfoPage.dart';
import 'package:flutter_application_1/src/presentation/page/roles/RolesPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  List<Widget> pageList = <Widget>[
    ClientMapSeekerPage(),
    ProfileInfoPage(),
    RolesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu de opciones"),
      ),
      body: BlocBuilder<DriverHomeBloc, DriverHomeState>(
        builder: (context, state) {
          return pageList[state.pageIndex];
        },
      ),
      drawer: BlocBuilder<DriverHomeBloc, DriverHomeState>(
        builder: (context, state) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: const [
                            Color.fromARGB(255, 0, 135, 43),
                            Color.fromARGB(255, 0, 227, 140)
                          ]),
                    ),
                    child: Text(
                      'Menu del conductor',
                      style: TextStyle(color: Colors.white),
                    )),
                ListTile(
                  title: Text('Mapa de viaje'),
                  selected: state.pageIndex == 0,
                  onTap: () {
                    context.read<DriverHomeBloc>().add(ChangeDrawerPage(pageIndex: 0));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Perfil del Usuario'),
                  selected: state.pageIndex == 1,
                  onTap: () {
                    context.read<DriverHomeBloc>().add(ChangeDrawerPage(pageIndex: 1));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Roles de Usuario'),
                  selected: state.pageIndex == 2,
                  onTap: () {
                    context.read<DriverHomeBloc>().add(ChangeDrawerPage(pageIndex: 2));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Cerrar sesion'),
                  onTap: () {
                    context.read<DriverHomeBloc>().add(Logout());
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (route) => false);
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
