import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/event_bus_events/event_bus.dart';
import 'package:salons_app_mobile/event_bus_events/user_registered_event.dart';

class RegistrationBloc {
  UpdateUserUseCase _updateUserUseCase;

  RegistrationBloc(this._updateUserUseCase);

  final _userUpdatedSubject = PublishSubject<UserEntity>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<UserEntity> get userUpdated => _userUpdatedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  updateUser(UserEntity user) async {
    _isLoadingSubject.add(true);

    final response = await _updateUserUseCase(user);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      eventBus.fire(UserRegisteredEvent());
      _userUpdatedSubject.add(response.right);
    }

    _isLoadingSubject.add(false);
  }
}
