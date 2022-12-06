import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class LoginBloc {
  LoginWithPhoneUseCase _loginWithPhoneUseCase;
  SignOutUseCase _signOutUseCase;

  LoginBloc(this._loginWithPhoneUseCase, this._signOutUseCase);

  final _codeSentSubject = PublishSubject<void>();
  final _loggedOutSubject = PublishSubject<void>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<void> get loggedOutSuccess => _loggedOutSubject.stream;

  Stream<void> get codeSentSuccess => _codeSentSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  void loginWithPhone(String phone) async {
    _isLoadingSubject.add(true);
    final response = await _loginWithPhoneUseCase(phone);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _codeSentSubject.add(null);
    }
    _isLoadingSubject.add(false);
  }

  void logout() async {
    final response = await _signOutUseCase();
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _loggedOutSubject.add(null);
    }
  }

// void loginWithGoogle() async {
//   _isLoadingSubject.add(true);
//   final response = await loginWithGoogleUseCase();
//   if (response.isLeft) {
//     _errorSubject.add(response.left.message);
//   } else {
//     _loggedInSubject.add(null);
//   }
//   _isLoadingSubject.add(false);
// }
//
// void loginWithFacebook() async {
//   _isLoadingSubject.add(true);
//   final response = await loginWithFacebookUseCase();
//   if (response.isLeft) {
//     _errorSubject.add(response.left.message);
//   } else {
//     _loggedInSubject.add(null);
//   }
//   _isLoadingSubject.add(false);
// }

}
