import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class ProfileState {}

class InitialProfileState extends ProfileState {}
class LoadingProfileState extends ProfileState {}
class ProfileLoadedState extends ProfileState {
  final UserEntity user;

  ProfileLoadedState(this.user);
}
class ProfileUpdatedState extends ProfileState {
  final UserEntity user;

  ProfileUpdatedState(this.user);
}
class ErrorProfileState extends ProfileState {
  final Failure failure;

  ErrorProfileState(this.failure);
}
