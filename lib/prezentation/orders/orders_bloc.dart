import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class OrdersBloc {
  final GetOrdersListUseCase _getOrdersListUseCase;
  final GetAvailableTimeUseCase _getAvailableTimeUseCase;
  final UpdateOrderUseCase _updateOrderUseCase;
  final LocalStorage _localStorage;

  OrdersBloc(this._getOrdersListUseCase, this._updateOrderUseCase,
      this._getAvailableTimeUseCase, this._localStorage);

  List<OrderEntity> _ordersList = [];

  final _ordersLoadedSubject = PublishSubject<List<OrderEntity>>();
  final _orderUpdatedSubject = PublishSubject<void>();
  final _errorSubject = PublishSubject<String>();
  final _isLoadingSubject = PublishSubject<bool>();

  // output stream
  Stream<List<OrderEntity>> get ordersLoaded => _ordersLoadedSubject.stream;

  Stream<void> get orderUpdated => _orderUpdatedSubject.stream;

  Stream<String> get errorMessage => _errorSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  getOrdersForCurrentUser(
      {String? dateFor, String? dateFrom, String? dateTo}) async {
    String userId = _localStorage.getUserId();
    final response = await _getOrdersListUseCase(userId, OrderForType.USER,
        dateFor: dateFor, dateFrom: dateFrom, dateTo: dateTo);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _ordersList = response.right;
      _ordersLoadedSubject.add(_ordersList);

      _localStorage.setOrdersList(_ordersList);
    }
  }

  getAvailableOrdersByTime(
      String salonId, String serviceId, String masterId, String date) async {
    final response =
        await _getAvailableTimeUseCase(salonId, serviceId, masterId, date);
    print("LoadAvailableTimeEvent");

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _ordersList = response.right;
      _ordersLoadedSubject.add(_ordersList);
    }
  }

  cancelOrder(OrderEntity order) async {
    //todo after canceling order should be checking on BE side if there is signed users on it and send push to them
    OrderEntity orderToUpdate = order.copy(clientName: "", clientId: "");
    final response = await _updateOrderUseCase(orderToUpdate);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      _ordersList.remove(orderToUpdate);
      _ordersLoadedSubject.add(_ordersList);

      _localStorage.setOrdersList(_ordersList);
    }
  }

  updateOrder(OrderEntity order) async {
    final response = await _updateOrderUseCase(order);

    if (response.isLeft) {
      _errorSubject.add(response.left.message);
    } else {
      // _ordersList[index] = response.right;
      // _ordersLoadedSubject.add(_ordersList);
      //
      // _localStorage.setOrdersList(_ordersList);
    }
  }

  pinOrder(OrderEntity order, int index) async {
    OrderEntity orderToUpdate = order;
    orderToUpdate.isPinned = !orderToUpdate.isPinned;

    if (_ordersList.contains(orderToUpdate)) {
      _ordersList[index] = orderToUpdate;
      _ordersLoadedSubject.add(_ordersList);

      _localStorage.setOrdersList(_ordersList);
    }
  }

  dispose() {
    _orderUpdatedSubject.close();
    _ordersLoadedSubject.close();
    _isLoadingSubject.close();
    _errorSubject.close();
  }
}
