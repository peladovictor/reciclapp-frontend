import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Role.dart';
import 'package:flutter_application_1/src/presentation/page/roles/RolesItem.dart';
import 'package:flutter_application_1/src/presentation/page/roles/bloc/RolesBloc.dart';
import 'package:flutter_application_1/src/presentation/page/roles/bloc/RolesState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RolesBloc, RolesState>(
        builder: (context, state) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Color.fromARGB(255, 12, 38, 145),
                  Color.fromARGB(255, 34, 156, 249),
                ])),
            child: ListView(
              shrinkWrap: true,
              children: state.roles != null
                  ? (state.roles?.map((Role role) {
                      return RolesItem(role);
                    }).toList()) as List<Widget>
                  : [],
            ),
          );
        },
      ),
    );
  }
}
