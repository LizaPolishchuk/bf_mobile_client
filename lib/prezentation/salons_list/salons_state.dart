import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class SalonsState {}

class InitialSalonsState extends SalonsState {}
class LoadingSalonsState extends SalonsState {}

class ErrorSalonsState extends SalonsState {
  final Failure failure;

  ErrorSalonsState(this.failure);
}
