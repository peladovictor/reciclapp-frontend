import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/presentation/utils/BlocFormItem.dart';
import 'package:flutter_application_1/src/presentation/utils/GalleryOrPhotoDialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/domain/models/user.dart';
import 'package:flutter_application_1/src/presentation/page/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:flutter_application_1/src/presentation/page/profile/update/bloc/ProfileUpdateEvent.dart';
import 'package:flutter_application_1/src/presentation/page/profile/update/bloc/ProfileUpdateState.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultTextField.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefoultIconBack.dart';

class ProfileUpdateContent extends StatelessWidget {
  User? user;
  ProfileUpdateState state;
  ProfileUpdateContent(this.state, this.user);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.formKey,
      child: Stack(
        children: [
          Column(
            children: [
              _headerProfile(context),
              Spacer(),
              _actionProfile(context, 'ACTUALIZAR USUARIO', Icons.check),
              SizedBox(
                height: 35,
              )
            ],
          ),
          _cardUserInfo(context),
          DefaultIconBack(
            margin: EdgeInsets.only(top: 60, left: 30),
          )
        ],
      ),
    );
  }

  Widget _imageUser(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GalleryOrPhotoDialog(
            context,
            () => {context.read<ProfileUpdateBloc>().add(PickImage())},
            () => {context.read<ProfileUpdateBloc>().add(TakePhoto())});
      },
      child: Container(
        width: 115,
        margin: EdgeInsets.only(top: 15, bottom: 15),
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipOval(
            child: user != null
                ? user!.image != null
                    ? FadeInImage.assetNetwork(
                        placeholder: 'assets/img/user_image.png',
                        image: user!.image!,
                        fit: BoxFit.cover,
                        fadeInDuration: Duration(seconds: 1),
                      )
                    : Image.asset(
                        'assets/img/user_image.png',
                      )
                : Image.asset(
                    'assets/img/user_image.png',
                  ),
          ),
        ),
      ),
    );
  }

  Widget _cardUserInfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 150),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            _imageUser(context),
            DefaultTextField(
              text: 'Nombre',
              icon: Icons.person,
              backgroundColor: Colors.grey[200]!,
              margin: EdgeInsets.only(left: 30, right: 30, top: 15),
              initialValue: user?.name,
              onChanged: (text) {
                context
                    .read<ProfileUpdateBloc>()
                    .add(NameChanged(name: BlocFormItem(value: text)));
              },
              validator: (value) {
                return state.name.error;
              },
            ),
            DefaultTextField(
              text: 'Apellido',
              icon: Icons.person_outline,
              backgroundColor: Colors.grey[200]!,
              initialValue: user?.lastname,
              margin: EdgeInsets.only(left: 30, right: 30, top: 15),
              onChanged: (text) {
                context
                    .read<ProfileUpdateBloc>()
                    .add(LastNameChanged(lastname: BlocFormItem(value: text)));
              },
              validator: (value) {
                return state.lastname.error;
              },
            ),
            DefaultTextField(
              text: 'Telefono',
              icon: Icons.phone,
              initialValue: user?.phone,
              backgroundColor: Colors.grey[200]!,
              margin: EdgeInsets.only(left: 30, right: 30, top: 15),
              onChanged: (text) {
                context
                    .read<ProfileUpdateBloc>()
                    .add(PhoneChanged(phone: BlocFormItem(value: text)));
              },
              validator: (value) {
                return state.phone.error;
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _actionProfile(BuildContext context, String option, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (state.formKey!.currentState != null) {
          if (state.formKey!.currentState!.validate()) {
            context.read<ProfileUpdateBloc>().add(FormSubmit());
          }
        } else {
          context.read<ProfileUpdateBloc>().add(FormSubmit());
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
        child: ListTile(
          title: Text(
            option,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 1, 152, 82),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerProfile(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 70),
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: const [
              Color.fromARGB(255, 0, 135, 43),
              Color.fromARGB(255, 0, 227, 140)
            ]),
      ),
      child: Text(
        'ACTUALIZAR PERFIL',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
