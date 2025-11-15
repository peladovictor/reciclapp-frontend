import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/user.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/page/profile/info/bloc/ProfileInfoBloc.dart';
import 'package:flutter_application_1/src/presentation/page/profile/info/bloc/ProfileInfoEvent.dart';
import 'package:flutter_application_1/src/presentation/page/profile/update/ProfileUpdateContent.dart';
import 'package:flutter_application_1/src/presentation/page/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:flutter_application_1/src/presentation/page/profile/update/bloc/ProfileUpdateEvent.dart';
import 'package:flutter_application_1/src/presentation/page/profile/update/bloc/ProfileUpdateState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  User? user;

  @override
  void initState() {
    //primer evento en dispararse - una sola vez
    // TODO: implement initState
    super.initState();
    print('METODO INIT STATE');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('METODO INIT STATE BINDING');
      context.read<ProfileUpdateBloc>().add(ProfileUpdateInitEvent(user: user));
    });
  }

  @override
  Widget build(BuildContext context) {
    //segundo - CTRL + S
    print('METODO BUILD');
    user = ModalRoute.of(context)?.settings.arguments as User;
    return Scaffold(
      body: BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
        listener: (context, state) {
          final response = state.response;

          // Si quieres, también puedes ver siempre qué llega:
          print('STATE RESPONSE => $response');

          if (response is ErrorData) {
            // 👇 ESTE ES EL PRINT QUE QUERÍAMOS AGREGAR
            print('ERROR UPDATE USER => ${response.message}');

            Fluttertoast.showToast(
              msg: response.message ?? 'Error al actualizar usuario',
              toastLength: Toast.LENGTH_LONG,
            );
          } else if (response is Success) {
            User user = response.data as User;

            print('UPDATE USER SUCCESS => ${user.toJson()}'); // opcional

            Fluttertoast.showToast(
              msg: 'Actualizacion exitosa',
              toastLength: Toast.LENGTH_LONG,
            );

            context.read<ProfileUpdateBloc>().add(UpdateUserSession(user: user));

            Future.delayed(const Duration(seconds: 2), () {
              context.read<ProfileInfoBloc>().add(GetUserInfo());
            });
          }

          // TODO: implement listener
        },
        child: BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
          builder: (context, state) {
            final response = state.response;
            if (response is Loading) {
              return Stack(
                children: [
                  ProfileUpdateContent(state, user),
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            }

            return ProfileUpdateContent(state, user);
          },
        ),
      ),
    );
  }
}
