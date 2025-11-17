import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/page/auth/login/LoginContent.dart';
import 'package:flutter_application_1/src/presentation/page/auth/login/bloc/LoginEvent.dart';
import 'package:flutter_application_1/src/presentation/page/auth/login/bloc/LoginState.dart';
import 'package:flutter_application_1/src/presentation/page/auth/login/bloc/LoginBloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // HOT RELOAD - CTRL + S
  // HOT RESTART - DESDE LOS BOTONES DE DART ACTUALIZAR
  // FULL RESTART - STOP

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color.from ARGB (255, 133, 255, 166),
        body: BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final response = state.response;
        if (response is ErrorData) {
          Fluttertoast.showToast(
              msg: '${response.message}', toastLength: Toast.LENGTH_LONG);
          print('Error Data: ${response.message}');
        } else if (response is Success) {
          Fluttertoast.showToast(
              msg: 'El login fue exitoso', toastLength: Toast.LENGTH_LONG);
          print('Success Dta: ${response.data}');
          final authResponse = response.data as AuthResponse;
          context.read<LoginBloc>().add(SaveUserSession(authResponse: authResponse));
          if (authResponse.user.roles!.length > 1) {
            Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, 'client/home', (route) => false);
          }
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          final response = state.response;
          if (response is Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return LoginContent(state);
        },
      ),
    ));
  }
}
