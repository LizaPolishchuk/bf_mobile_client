import 'package:meta/meta.dart';

@immutable
abstract class NavState {}

class InitialNavState extends NavState {}

class NavigationResultedState extends NavState {
  final dynamic result;

  NavigationResultedState(this.result);
}