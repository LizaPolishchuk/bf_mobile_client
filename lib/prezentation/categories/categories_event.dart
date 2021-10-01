import 'package:meta/meta.dart';

@immutable
abstract class CategoriesEvent {}

class LoadCategoriesListEvent extends CategoriesEvent {
  final String salonId;

  LoadCategoriesListEvent(this.salonId);
}

class SearchCategoriesEvent extends CategoriesEvent {
  final String searchKey;

  SearchCategoriesEvent(this.searchKey);
}
