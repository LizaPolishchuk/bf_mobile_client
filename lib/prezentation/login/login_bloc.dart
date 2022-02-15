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
      : super(InitialLoginState()){
    streamController = StreamController<int?>.broadcast();
  }

  @override
  LoginState get initialState => InitialLoginState();

  late StreamController<int?> streamController;
  StreamSink<int?> get streamSink => streamController.sink;
  Stream<int?> get streamTime => streamController.stream;
  int _timeToResendCode = 60;
  Timer? _timer;

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
      yield loginResult.fold((failure) => ErrorLoginState(failure),
          (_) => VerifyCodeSentState());
    }  else if (event is ResendCodePhoneEvent) {
      yield LoadingCodeVerifyState();
      final loginResult = await loginWithPhoneUseCase(event.phone);
      yield loginResult.fold((failure) => ErrorCodeVerifyState(failure),
          (_) => VerifyCodeResentState());
    } else if (event is LoginWithPhoneVerifyCodeEvent) {
      yield LoadingCodeVerifyState();
      final loginResult = await loginWithPhoneVerifyCodeUseCase(event.code, event.phoneNumber);
      yield loginResult.fold((failure) => ErrorCodeVerifyState(failure),
              (response) {
            return LoggedInState(response.keys.first, response.values.first);
          });
    } else if (event is LogoutEvent) {
      yield LoadingLoginState();
      final signoutResult = await signOut();
      yield* _signedOutOrFailure(signoutResult);
    } else if (event is StartTimerEvent) {
      _timeToResendCode = 60;
      _timer = Timer.periodic(
        const Duration(seconds: 1),
            (Timer timer) {
          if (_timeToResendCode == 0) {
            streamSink.add(null);
            timer.cancel();
          } else {
            _timeToResendCode--;
            streamSink.add(_timeToResendCode);
          }
        },
      );
    }
  }

  Stream<LoginState> _loggedInOrFailure(
    Either<Failure, Map<UserEntity, bool?>> failureOrUserId,
  ) async* {
    yield failureOrUserId.fold((failure) => ErrorLoginState(failure),
        (response) {
      return LoggedInState(response.keys.first, response.values.first);
    });
  }

  Stream<LoginState> _signedOutOrFailure(
    Either<Failure, void> failureOrUserId,
  ) async* {
    yield failureOrUserId.fold((failure) => ErrorLoginState(failure),
        (voidResult) => LoggedOutState());
  }

  void dispose() {
    streamController.close();
    _timer?.cancel();
  }
}
