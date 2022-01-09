import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class SearchFiltersState {}

class InitialFiltersState extends SearchFiltersState {}
class LoadingFiltersState extends SearchFiltersState {}

class FiltersLoadedState extends SearchFiltersState {
  final Filters filters;

  FiltersLoadedState(this.filters);
}
class ErrorFiltersState extends SearchFiltersState {
  final Failure failure;

  ErrorFiltersState(this.failure);
}
