import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class RegistrationState {}

class InitialRegistrationState extends RegistrationState {}
class LoadingRegistrationState extends RegistrationState {}
class UserUpdatedState extends RegistrationState {}
class ErrorRegistrationState extends RegistrationState {
  final Failure failure;

  ErrorRegistrationState(this.failure);
}
