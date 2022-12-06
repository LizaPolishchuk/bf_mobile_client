import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class SearchFiltersBloc {
  final GetFiltersUseCase _getFiltersUseCase;

  SearchFiltersBloc(
    this._getFiltersUseCase,
  );

  final _filtersLoadedSubject = PublishSubject<Filters>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<Filters> get filtersLoaded => _filtersLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  loadSearchFilters() async {
    var response = await _getFiltersUseCase();

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _filtersLoadedSubject.add(response.right);
    }
  }
}
