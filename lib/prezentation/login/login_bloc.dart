import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginWithGoogleUseCase loginWithGoogle;
  LoginWithFacebookUseCase loginWithFacebook;
  LoginWithPhoneUseCase loginWithPhoneUseCase;
  LoginWithPhoneVerifyCodeUseCase loginWithPhoneVerifyCodeUseCase;
  SignOutUseCase signOut;

  LoginBloc(
      this.loginWithGoogle,
      this.loginWithFacebook,
      this.loginWithPhoneUseCase,
      this.loginWithPhoneVerifyCodeUseCase,
      this.signOut)
      : super(InitialLoginState());

  @override
  LoginState get initialState => InitialLoginState();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginWithGoogleEvent) {
      yield LoadingLoginState();
      final loginResult = await loginWithGoogle();
      yield* _loggedInOrFailure(loginResult);
    } else if (event is LoginWithFacebookEvent) {
      yield LoadingLoginState();
      final loginResult = await loginWithFacebook();
      yield* _loggedInOrFailure(loginResult);
    } else if (event is LoginWithPhoneEvent) {
      yield LoadingLoginState();
      final loginResult = await loginWithPhoneUseCase(event.phone);
      bool noError = loginResult.getOrElse(() => false) ?? false;
      if (noError) {
        yield VerifyCodeSentState();
      } else {
        yield ErrorLoginState(null, null, "Something went wrong");
      }
    } else if (event is LoginWithPhoneVerifyCodeEvent) {
      yield LoadingLoginState();
      final loginResult = await loginWithPhoneVerifyCodeUseCase(event.code);
      yield* _loggedInOrFailure(loginResult);
    } else if (event is LogoutEvent) {
      yield LoadingLoginState();
      final signoutResult = await signOut();
      yield* _signedOutOrFailure(signoutResult);
    }
  }

  Stream<LoginState> _loggedInOrFailure(
    Either<Failure, String> failureOrUserId,
  ) async* {
    yield failureOrUserId.fold(
        (failure) =>
            ErrorLoginState(failure.code, failure.codeStr, failure.message),
        (userId) {
      return LoggedInState();
    });
  }

  Stream<LoginState> _signedOutOrFailure(
    Either<Failure, void> failureOrUserId,
  ) async* {
    yield failureOrUserId.fold(
        (failure) =>
            ErrorLoginState(failure.code, failure.codeStr, failure.message),
        (voidResult) => LoggedOutState());
  }
}
