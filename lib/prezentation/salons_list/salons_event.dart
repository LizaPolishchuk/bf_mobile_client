import 'package:meta/meta.dart';

@immutable
abstract class SalonsEvent {}

class LoadSalonsEvent  extends SalonsEvent {
  final String searchText;

  LoadSalonsEvent(this.searchText);
}

class LoadTopSalonsEvent extends SalonsEvent {}
