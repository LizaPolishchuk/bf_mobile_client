import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoriesState {}

class InitialCategoriesListState extends CategoriesState {}

class CategoriesListLoadedState extends CategoriesState {
  final List<Category> categories;

  CategoriesListLoadedState(this.categories);
}

class LoadCategoriesErrorState extends CategoriesState {
  final String errorMessage;

  LoadCategoriesErrorState(this.errorMessage);
}
