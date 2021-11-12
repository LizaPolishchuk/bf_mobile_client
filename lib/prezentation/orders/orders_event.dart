import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class OrdersEvent {}

class LoadOrdersForCurrentUserEvent extends OrdersEvent{
  final String? dateFor;
  final String? dateFrom;
  final String? dateTo;

  LoadOrdersForCurrentUserEvent({this.dateFor, this.dateFrom, this.dateTo});
}

class LoadAvailableOrdersByTimeEvent extends OrdersEvent{
  final String salonId;
  final String serviceId;
  final String masterId;
  final String date;

  LoadAvailableOrdersByTimeEvent(this.salonId, this.serviceId, this.masterId, this.date);
}

class PinOrderEvent extends OrdersEvent {
  final OrderEntity orderEntity;

  PinOrderEvent(this.orderEntity);
}
class CancelOrderEvent extends OrdersEvent {
  final OrderEntity orderEntity;

  CancelOrderEvent(this.orderEntity);
}
class UpdateOrderEvent extends OrdersEvent {
  final OrderEntity orderEntity;

  UpdateOrderEvent(this.orderEntity);
}

