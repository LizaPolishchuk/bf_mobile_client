import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ServicesBloc {
  final GetServicesListUseCase _getServicesListUseCase;

  List<Service> _servicesList = [];

  ServicesBloc(this._getServicesListUseCase);

  final _servicesLoadedSubject = PublishSubject<List<Service>>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  void dispoce() => _isLoadingSubject.close();

  // output stream
  Stream<List<Service>> get servicesLoaded => _servicesLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getServices(String salonId, String? categoryId) async {
    var response = await _getServicesListUseCase(salonId, categoryId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _servicesList = response.right;
      _servicesLoadedSubject.add(_servicesList);
    }
  }
}
