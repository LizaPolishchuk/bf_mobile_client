import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_event.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  UpdateUserUseCase updateUserUseCase;

  RegistrationBloc(this.updateUserUseCase)
      : super(InitialRegistrationState());

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is UpdateUserEvent) {
      yield LoadingRegistrationState();
      final updateResult = await updateUserUseCase(event.user);
      yield updateResult.fold((error) => ErrorRegistrationState(error), (user) {
        return UserUpdatedState();
      });
    }
  }
}
