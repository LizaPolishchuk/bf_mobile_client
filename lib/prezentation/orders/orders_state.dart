import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class OrdersState {}

class InitialOrdersState extends OrdersState {}

class ErrorOrdersState extends OrdersState {
  final Failure failure;

  ErrorOrdersState(this.failure);
}
