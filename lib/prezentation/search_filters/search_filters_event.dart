import 'package:meta/meta.dart';

@immutable
abstract class SearchFiltersEvent {}

class LoadFiltersEvent  extends SearchFiltersEvent {}

