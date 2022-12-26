import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent {}

class LoginWithGoogleEvent extends LoginEvent {}

class LoginWithFacebookEvent extends LoginEvent {}

class LoginWithPhoneEvent extends LoginEvent {
  final String phone;

  LoginWithPhoneEvent(this.phone);
}

class ResendCodePhoneEvent extends LoginEvent {
  final String phone;

  ResendCodePhoneEvent(this.phone);
}

class LoginWithPhoneVerifyCodeEvent extends LoginEvent {
  final String code;
  final String phoneNumber;

  LoginWithPhoneVerifyCodeEvent(this.code, this.phoneNumber);
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

class StartTimerEvent extends LoginEvent {}
