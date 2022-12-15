import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class CategoriesBloc {
  final GetCategoriesListUseCase _getCategoriesListUseCase;

  List<Category> categoryList = [];

  CategoriesBloc(this._getCategoriesListUseCase);

  List<Category> categoriesList = [];

  final _categoriesLoadedSubject = PublishSubject<List<Category>>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  void dispoce() => _isLoadingSubject.close();

  // output stream
  Stream<List<Category>> get categoriesLoaded =>
      _categoriesLoadedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getCategories(String salonId) async {
    var response = await _getCategoriesListUseCase(salonId);
    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      categoriesList = response.right;
      _categoriesLoadedSubject.add(categoriesList);
    }
  }

  searchCategories(String searchKey) async {
    List<Category> foundCategories =
        categoryList.where((categ) => categ.name.contains(searchKey)).toList();

    _categoriesLoadedSubject.add(foundCategories);
  }
}
