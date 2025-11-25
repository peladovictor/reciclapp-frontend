import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/presentation/page/auth/login/bloc/LoginState.dart';
import 'package:flutter_application_1/src/presentation/page/auth/login/bloc/LoginEvent.dart';
import 'package:flutter_application_1/src/presentation/page/auth/login/bloc/LoginBloc.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormitem.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultButton.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultTextField.dart';

class LoginContent extends StatelessWidget {
  final LoginState state;

  const LoginContent(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.formKey,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Color.fromARGB(255, 0, 135, 43),
                    Color.fromARGB(255, 0, 227, 140)
                  ]),
            ),
            padding: EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, //vertical
              mainAxisAlignment: MainAxisAlignment.center, //horizontal
              children: [
                _textLoginRotate(),
                SizedBox(height: 100),
                _textRegisterRotated(context),
                SizedBox(height: 90)
              ],
            ),
          ),
          Container(
            //opcion 1
            //height: MediaQuery.of(context).size.height * 0.96,
            //width: MediaQuery.of(context).size.width * 0.8,
            //botom opcion 2
            margin: EdgeInsets.only(left: 60, right: 0, bottom: 10),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color.fromARGB(255, 0, 135, 43),
                      Color.fromARGB(255, 0, 198, 237)
                    ]),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45), bottomLeft: Radius.circular(45))),
            child: Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(left: 25, right: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    _textWelcomeBack('Aqui cuidamos el'),
                    _textWelcomeBack('Planeta...'),
                    _imageCar(),
                    _textLogin(),
                    DefaultTextField(
                        onChanged: (text) {
                          context
                              .read<LoginBloc>()
                              .add(EmailChanged(email: BlocFormItem(value: text)));
                        },
                        validator: (value) {
                          return state.email.error;
                        },
                        text: 'Email',
                        icon: Icons.email_outlined),
                    DefaultTextField(
                      onChanged: (text) {
                        context
                            .read<LoginBloc>()
                            .add(PasswordChanged(password: BlocFormItem(value: text)));
                      },
                      validator: (value) {
                        return state.password.error;
                      },
                      text: 'Password',
                      icon: Icons.lock_outline,
                      margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    //Spacer(),
                    DefaultButton(
                      text: 'LOGIN',
                      onPressed: () {
                        final form = state.formKey?.currentState;
                        if (form != null && form.validate()) {
                          context.read<LoginBloc>().add(FormSubmit());
                        } else {
                          print('El formulario no es valido');
                        }
                      },
                      color: Colors.orange,
                      textColor: Colors.white,
                    ),

                    _separatorOR(),
                    SizedBox(height: 10),
                    _textDontHaveAccount(context),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textDontHaveAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No tienes cuenta?',
          style: TextStyle(color: Colors.grey[100], fontSize: 17),
        ),
        SizedBox(width: 7),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'register');
          },
          child: Text(
            'Registrate',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
      ],
    );
  }

  Widget _separatorOR() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 25,
          height: 1,
          color: Colors.white,
          margin: EdgeInsets.only(right: 5),
        ),
        Text(
          'O',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        Container(
          width: 25,
          height: 1,
          color: Colors.white,
          margin: EdgeInsets.only(left: 5),
        ),
      ],
    );
  }

  Widget _textLogin() {
    return Text(
      'Log in',
      style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget _imageCar() {
    return Container(
      alignment: Alignment.centerRight,
      child: Image.asset(
        'assets/img/camionrecolectiorbase.png',
        width: 280,
        height: 280,
      ),
    );
  }

  Widget _textWelcomeBack(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget _textRegisterRotated(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'register');
      },
      child: RotatedBox(
        quarterTurns: 1,
        child: Text(
          'Registro',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
    );
  }

  Widget _textLoginRotate() {
    return RotatedBox(
      quarterTurns: 1,
      child: Text(
        'Login',
        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
