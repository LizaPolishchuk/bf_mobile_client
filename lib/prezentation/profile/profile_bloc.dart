import 'dart:async';
import 'dart:io';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ProfileBloc {
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final UpdateUserAvatarUseCase _updateUserAvatarUseCase;
  final LocalStorage _localStorage;

  ProfileBloc(this._getUserUseCase, this._updateUserUseCase,
      this._updateUserAvatarUseCase, this._localStorage);

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
    _isLoadingSubject.add(true);

    String userId = _localStorage.getUserId();
    final response = await _getUserUseCase(userId);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _profileLoadedSubject.add(response.right);
    }

    _isLoadingSubject.add(false);
  }

  updateUser(UserEntity user, {File? userAvatar}) async {
    _isLoadingSubject.add(true);

    UserEntity userToUpdate = user;

    if (userAvatar != null) {
      final response = await _updateUserAvatarUseCase(userAvatar!);

      if (response.isLeft) {
        _errorSubject.add(response.left.message);
      } else {
        String url = response.right;

        if (url.isEmpty) {
          _errorSubject.add("error");
        } else {
          userToUpdate.avatar = url;
          final updateResult = await _updateUserUseCase(userToUpdate);

          if (updateResult.isLeft) {
            _errorSubject.add(updateResult.left.message);
          } else {
            _profileUpdatedSubject.add(updateResult.right);
          }
        }
      }
    }

    _isLoadingSubject.add(false);
  }
}
