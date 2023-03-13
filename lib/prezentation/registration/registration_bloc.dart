

// class RegistrationBloc {
//   UpdateUserUseCase _updateUserUseCase;
//
//   RegistrationBloc(this._updateUserUseCase);
//
//   final _userUpdatedSubject = PublishSubject<UserEntity>();
//   final _errorSubject = PublishSubject<String>();
//   final _isLoadingSubject = PublishSubject<bool>();
//
//   // output stream
//   Stream<UserEntity> get userUpdated => _userUpdatedSubject.stream;
//
//   Stream<String> get errorMessage => _errorSubject.stream;
//
//   Stream<bool> get isLoading => _isLoadingSubject.stream;
//
//   updateUser(UserEntity user) async {
//     _isLoadingSubject.add(true);
//
//     final response = await _updateUserUseCase(user);
//
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       eventBus.fire(UserRegisteredEvent());
//       _userUpdatedSubject.add(response.right);
//     }
//
//     _isLoadingSubject.add(false);
//   }
// }
