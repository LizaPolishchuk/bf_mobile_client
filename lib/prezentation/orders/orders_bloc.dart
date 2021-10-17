import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_event.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersListUseCase getOrdersListUseCase;
  final GetAvailableTimeUseCase getAvailableTimeUseCase;
  final UpdateOrderUseCase updateOrderUseCase;
  final LocalStorage localStorage;

  List<OrderEntity> ordersList = [];

  late StreamController<List<OrderEntity>> streamController;

  StreamSink<List<OrderEntity>> get ordersStreamSink => streamController.sink;

  Stream<List<OrderEntity>> get streamOrders => streamController.stream;

  OrdersBloc(this.getOrdersListUseCase, this.updateOrderUseCase, this.getAvailableTimeUseCase,
      this.localStorage)
      : super(InitialOrdersState()) {
    streamController = StreamController<List<OrderEntity>>.broadcast();
  }

  void dispose() {
    streamController.close();
  }

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is LoadOrdersForCurrentUserEvent) {
      String userId = localStorage.getUserId();
      final ordersListOrError = await getOrdersListUseCase(userId, OrderForType.USER);
      ordersListOrError.fold((failure) {
        ordersStreamSink.addError(failure.message);
      }, (ordersList) {
        this.ordersList = ordersList;
        localStorage.setOrdersList(ordersList);
        ordersStreamSink.add(ordersList);
      });
    }else if (event is LoadAvailableTimeEvent) {

      final ordersListOrError = await getAvailableTimeUseCase(event.salonId, event.serviceId, event.masterId, event.date);
      print("LoadAvailableTimeEvent");

      ordersListOrError.fold((failure) {
        ordersStreamSink.addError(failure.message);
      }, (ordersList) {
        this.ordersList = ordersList;
        localStorage.setOrdersList(ordersList);
        ordersStreamSink.add(ordersList);
      });
    } else if (event is CancelOrderEvent) {
      //todo after canceling order should be checking on BE side if there is signed users on it and send push to them
      OrderEntity orderToUpdate =
          event.orderEntity.copy(clientName: "", clientId: "");
      final successOrError = await updateOrderUseCase(orderToUpdate);

      successOrError.fold((failure) {
        ordersStreamSink.addError(failure.message);
      }, (_) {
        ordersList.remove(orderToUpdate);
        localStorage.setOrdersList(ordersList);
        ordersStreamSink.add(ordersList);
      });
    } else if (event is PinOrderEvent) {
      OrderEntity orderToUpdate = event.orderEntity;
      orderToUpdate.isPinned = !orderToUpdate.isPinned;

      if (ordersList.contains(orderToUpdate)) {
        ordersList[ordersList.indexOf(orderToUpdate)] = orderToUpdate;
        localStorage.setOrdersList(ordersList);
        ordersStreamSink.add(ordersList);
      }
    }
  }
}
