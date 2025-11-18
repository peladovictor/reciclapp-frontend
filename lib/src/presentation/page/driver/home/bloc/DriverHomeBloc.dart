import 'package:flutter_application_1/src/domain/useCases/auth/AuthUseCase.dart';
import 'package:flutter_application_1/src/presentation/page/driver/home/bloc/DriverHomeEvent.dart';
import 'package:flutter_application_1/src/presentation/page/driver/home/bloc/DriverHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {
  AuthUseCases authUseCases;

  DriverHomeBloc(this.authUseCases) : super(DriverHomeState()) {
    on<ChangeDrawerPage>((event, emit) {
      emit(state.copyWith(pageIndex: event.pageIndex));
    });

    on<Logout>((event, emit) async {
      await authUseCases.logout.run();
    });
  }
}
