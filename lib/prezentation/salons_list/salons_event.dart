import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class SalonsEvent {}

class LoadSalonsEvent  extends SalonsEvent {
  final String searchText;
  final SearchFilters? searchFilters;

  LoadSalonsEvent(this.searchText, {this.searchFilters});
}

class LoadTopSalonsEvent extends SalonsEvent {}
