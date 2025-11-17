import 'package:flutter_application_1/src/domain/models/AuthResponse.dart';
import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCase.dart';
import 'package:flutter_application_1/src/presentation/page/roles/bloc/RolesEvent.dart';
import 'package:flutter_application_1/src/presentation/page/roles/bloc/RolesState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  AuthUseCases authUseCases;

  RolesBloc(this.authUseCases) : super(RolesState()) {
    on<GetRolesList>((event, emit) async {
      AuthResponse? authResponse = await authUseCases.getUserSession.run();
      emit(state.copyWith(roles: authResponse?.user.roles));
    });
  }
}
