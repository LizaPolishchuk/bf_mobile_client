import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class OrdersEvent {}

class LoadOrdersForCurrentUserEvent extends OrdersEvent{}

class LoadAvailableTimeEvent extends OrdersEvent{
  final String salonId;
  final String serviceId;
  final String masterId;
  final String date;

  LoadAvailableTimeEvent(this.salonId, this.serviceId, this.masterId, this.date);
}

class PinOrderEvent extends OrdersEvent {
  final OrderEntity orderEntity;

  PinOrderEvent(this.orderEntity);
}
class CancelOrderEvent extends OrdersEvent {
  final OrderEntity orderEntity;

  CancelOrderEvent(this.orderEntity);
}

