import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/profile/profile_event.dart';
import 'package:salons_app_mobile/prezentation/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final UpdateUserAvatarUseCase updateUserAvatarUseCase;
  final LocalStorage localStorage;

  ProfileBloc(this.getUserUseCase, this.updateUserUseCase,
      this.updateUserAvatarUseCase, this.localStorage)
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

      UserEntity userToUpdate = event.user;

      print("event is UpdateProfileEvent");

      if (event.userAvatar != null) {
        final updateAvatarResult =
            await updateUserAvatarUseCase(event.userAvatar!);

        if (updateAvatarResult.isLeft()) {
          yield ErrorProfileState(Failure());
        } else {
          String url = updateAvatarResult.getOrElse(() => "");

          if (url.isEmpty) {
            yield ErrorProfileState(Failure());
          } else {
            userToUpdate.avatar = url;
            final updateResult = await updateUserUseCase(userToUpdate);

            yield updateResult.fold((error) => ErrorProfileState(error),
                (user) => ProfileUpdatedState(user));
          }
        }
      } else {
        final updateResult = await updateUserUseCase(userToUpdate);

        yield updateResult.fold((error) => ErrorProfileState(error),
            (user) => ProfileUpdatedState(user));
      }
    }
  }
}
