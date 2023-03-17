import 'package:bf_network_module/bf_network_module.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginState {}

class InitialLoginState extends LoginState {}

class LoadingLoginState extends LoginState {}

class LoadingCodeVerifyState extends LoginState {}

class LoggedInState extends LoginState {
  final UserEntity user;
  final bool? isNewUser;

  LoggedInState(this.user, this.isNewUser);
}

class VerifyCodeSentState extends LoginState {
  VerifyCodeSentState();
}

class VerifyCodeResentState extends LoginState {
  VerifyCodeResentState();
}

class LoggedOutState extends LoginState {}

class ErrorLoginState extends LoginState {
  final Failure failure;

  ErrorLoginState(this.failure);
}

class ErrorCodeVerifyState extends LoginState {
  final Failure failure;

  ErrorCodeVerifyState(this.failure);
}
