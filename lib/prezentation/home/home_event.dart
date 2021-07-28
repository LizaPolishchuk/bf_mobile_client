import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';


@immutable
abstract class HomeEvent {}

class LoadOrdersForCurrentUserEvent extends HomeEvent{}

class PinOrderEvent extends HomeEvent {
  final OrderEntity orderEntity;

  PinOrderEvent(this.orderEntity);
}
class CancelOrderEvent extends HomeEvent {
  final OrderEntity orderEntity;

  CancelOrderEvent(this.orderEntity);
}

