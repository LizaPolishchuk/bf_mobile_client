import 'package:meta/meta.dart';

@immutable
abstract class SalonsEvent {}

class SearchSalonsEvent extends SalonsEvent {
  final String searchText;

  SearchSalonsEvent(this.searchText);
}

class LoadTopSalonsEvent extends SalonsEvent {}
