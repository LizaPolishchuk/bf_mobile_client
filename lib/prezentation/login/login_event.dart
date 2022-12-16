import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent {}

class LoginWithGoogleEvent extends LoginEvent {}

class LoginWithFacebookEvent extends LoginEvent {}

class LoginWithEmailAndPasswordEvent extends LoginEvent {
  final String email;
  final String password;

  LoginWithEmailAndPasswordEvent(this.email, this.password);
}

class SignUpWithEmailAndPasswordEvent extends LoginEvent {
  final String email;
  final String password;

  SignUpWithEmailAndPasswordEvent(this.email, this.password);
}

class LogoutEvent extends LoginEvent {}
