import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class SalonDetailsBloc {
  final GetSalonByIdUseCase _getSalonByIdUseCase;

  SalonDetailsBloc(this._getSalonByIdUseCase);

  final _salonLoadedSubject = PublishSubject<Salon>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<Salon> get salonLoaded => _salonLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  loadSalonById(String salonId) async {
    _isLoadingSubject.add(true);

    final response = await _getSalonByIdUseCase(salonId);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _salonLoadedSubject.add(response.right);
    }

    _isLoadingSubject.add(false);
  }
}
