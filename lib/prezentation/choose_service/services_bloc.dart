import 'dart:async';

import 'package:bf_mobile_client/utils/error_parser.dart';
import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ServicesBloc {
  final ServiceRepository _serviceRepository;

  ServicesBloc(this._serviceRepository);

  final _servicesLoadedSubject = PublishSubject<List<Service>>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<Service>> get servicesLoaded => _servicesLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getServices(String salonId, String? categoryId) async {
    try {
      var response = await _serviceRepository.getSalonServices(salonId);
      _servicesLoadedSubject.add(response);
    } catch (error) {
      _errorSubject.add(ErrorParser.parseError(error));
    }
  }
}
