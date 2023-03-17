import 'dart:async';

import 'package:bf_mobile_client/build_info.dart';
import 'package:bf_mobile_client/event_bus_events/event_bus.dart';
import 'package:bf_mobile_client/event_bus_events/user_success_logged_in_event.dart';
import 'package:bf_mobile_client/prezentation/login/login_bloc.dart';
import 'package:bf_mobile_client/utils/notifications/notifications_manager.dart';
import 'package:bf_network_module/bf_network_module.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/subjects.dart';

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

  void verifyCode(BuildContext context, String phone, String code) async {
    _isLoadingSubject.add(true);
    final response = await _verifyCodeUseCase(code, phone);
    _isLoadingSubject.add(false);

    if (response.isLeft) {
      String errorMsg = (response.left.codeStr == "invalid-verification-code")
          ? AppLocalizations.of(context)!.wrongCode
          : kDebugMode
              ? response.left.message
              : AppLocalizations.of(context)!.somethingWentWrong;

      _errorSubject.add(errorMsg);
    } else {
      _loggedInSubject.add(response.right);

      await NotificationsManager().bindToken(BuildInfo().pushToken!);

      eventBus.fire(UserSuccessLoggedInEvent(
          response.right.values.first ?? false, response.right.keys.first));
    }
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
