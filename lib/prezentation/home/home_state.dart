import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class HomeState {}

class InitialHomeState extends HomeState {}

class LoggedOutState extends HomeState {}

class ErrorHomeState extends HomeState {
  final Failure failure;

  ErrorHomeState(this.failure);
}
