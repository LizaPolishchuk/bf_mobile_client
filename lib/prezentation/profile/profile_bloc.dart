import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/profile/profile_event.dart';
import 'package:salons_app_mobile/prezentation/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final LocalStorage localStorage;

  ProfileBloc(this.getUserUseCase, this.updateUserUseCase, this.localStorage)
      : super(InitialProfileState());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is GetProfileEvent) {
      yield LoadingProfileState();

      final currentUserId = localStorage.getUserId();
      final userOrError = await getUserUseCase(currentUserId);

      yield userOrError.fold((error) => ErrorProfileState(error),
          (user) => ProfileLoadedState(user));
    }
    if (event is UpdateProfileEvent) {
      yield LoadingProfileState();

      final updateResult = await updateUserUseCase(event.user);
      yield updateResult.fold(
          (error) => ErrorProfileState(error), (user) => ProfileUpdatedState(event.user));
    }
  }
}
