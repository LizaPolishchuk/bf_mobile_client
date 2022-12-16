import 'package:meta/meta.dart';

@immutable
abstract class LoginState {}

class InitialLoginState extends LoginState {}
class LoadingLoginState extends LoginState {}
class LoggedInState extends LoginState {}
class LoggedOutState extends LoginState {}
class ErrorLoginState extends LoginState {
  final String errorMessage;
  final String? errorCode;

  ErrorLoginState(this.errorCode, this.errorMessage);
}
