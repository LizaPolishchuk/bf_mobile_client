import 'package:meta/meta.dart';

@immutable
abstract class LoginState {}

class InitialLoginState extends LoginState {}
class LoadingLoginState extends LoginState {}
class LoggedInState extends LoginState {}
class VerifyCodeSentState extends LoginState {}
class LoggedOutState extends LoginState {}
class ErrorLoginState extends LoginState {
  final String errorMessage;
  final String? errorCodeStr;
  final int? errorCode;

  ErrorLoginState(this.errorCode, this.errorCodeStr, this.errorMessage);
}
