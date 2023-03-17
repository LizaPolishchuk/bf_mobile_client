import 'dart:async';
import 'dart:io';

import 'package:bf_mobile_client/utils/error_parser.dart';
import 'package:bf_network_module/bf_network_module.dart';
import 'package:rxdart/subjects.dart';

class ProfileBloc {
  final UserRepository _userRepository;
  final LocalStorage _localStorage;

  ProfileBloc(this._userRepository, this._localStorage);

  final _profileLoadedSubject = PublishSubject<UserEntity>();
  final _profileUpdatedSubject = PublishSubject<UserEntity>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<UserEntity> get profileLoaded => _profileLoadedSubject.stream;

  Stream<UserEntity> get profileUpdated => _profileUpdatedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  loadUserProfile() async {
    try {
      _isLoadingSubject.add(true);

      String userId = _localStorage.getUserId();
      var response = await _userRepository.getUser(userId);
      _profileLoadedSubject.add(response);

      _isLoadingSubject.add(false);
    } catch (error) {
      _isLoadingSubject.add(false);
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }

  updateUser(UserEntity user, {File? userAvatar}) async {
    try {
      _isLoadingSubject.add(true);

      var response = await _userRepository.updateUser(user);
      _profileUpdatedSubject.add(user);

      _isLoadingSubject.add(false);
    } catch (error) {
      _isLoadingSubject.add(false);
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }
}
