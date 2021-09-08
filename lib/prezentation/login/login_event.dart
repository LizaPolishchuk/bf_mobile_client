import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent {}

class LoginWithGoogleEvent extends LoginEvent {}

class LoginWithFacebookEvent extends LoginEvent {}

class LoginWithPhoneEvent extends LoginEvent {
  final String phone;

  LoginWithPhoneEvent(this.phone);
}

class LoginWithPhoneVerifyCodeEvent extends LoginEvent {
  final String code;

  LoginWithPhoneVerifyCodeEvent(this.code);
}

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
