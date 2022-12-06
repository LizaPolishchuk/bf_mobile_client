import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/event_bus_events/event_bus.dart';
import 'package:salons_app_mobile/event_bus_events/user_success_logged_in_event.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/login/login_bloc.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';

class CodeVerifyBloc {
  LoginWithPhoneVerifyCodeUseCase _verifyCodeUseCase;
  LoginBloc? _loginBloc;

  CodeVerifyBloc(this._verifyCodeUseCase);

  int _timeToResendCode = 60;
  Timer? _timer;

  final _loggedInSubject = PublishSubject<Map<UserEntity, bool?>>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();
  final _timeToResendCodeSubject = PublishSubject<int?>();

  setLoginBloc(LoginBloc loginBloc) {
    _loginBloc = loginBloc;
  }

  // output stream
  Stream<Map<UserEntity, bool?>> get loggedInSuccess => _loggedInSubject.stream;

  Stream<int?> get resendCodeTime => _timeToResendCodeSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  void verifyCode(String phone, String code) async {
    _isLoadingSubject.add(true);
    final response = await _verifyCodeUseCase(code, phone);

    if (response.isLeft) {
      String errorMsg = (response.left.codeStr == "invalid-verification-code")
          ? tr(AppStrings.wrongCode)
          : kDebugMode
              ? response.left.message
              : tr(AppStrings.somethingWentWrong);

      _errorSubject.add(errorMsg);
    } else {
      _loggedInSubject.add(response.right);
      eventBus.fire(UserSuccessLoggedInEvent(
          response.right.values.first ?? false, response.right.keys.first));
    }
    _isLoadingSubject.add(false);
  }

  void resendCode(String phone) async {
    startTimerToResendCode();
    _loginBloc?.loginWithPhone(phone);
  }

  void startTimerToResendCode() {
    _timeToResendCode = 60;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_timeToResendCode == 0) {
          _timeToResendCodeSubject.add(null);
          timer.cancel();
        } else {
          _timeToResendCode--;
          _timeToResendCodeSubject.add(_timeToResendCode);
        }
      },
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}
