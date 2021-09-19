import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOrdersListForCurrentUser getOrdersListForCurrentUser;
  final UpdateOrderUseCase updateOrderUseCase;
  final SignOutUseCase signOutUseCase;
  final LocalStorage localStorage;

  List<OrderEntity> ordersList = [];

  late StreamController<List<OrderEntity>> streamController;

  StreamSink<List<OrderEntity>> get ordersStreamSink => streamController.sink;

  Stream<List<OrderEntity>> get streamOrders => streamController.stream;

  HomeBloc(this.getOrdersListForCurrentUser, this.updateOrderUseCase, this.signOutUseCase,
      this.localStorage)
      : super(InitialHomeState()) {
    streamController = StreamController<List<OrderEntity>>.broadcast();
  }

  void dispose() {
    streamController.close();
  }

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is LoadOrdersForCurrentUserEvent) {
      // if(localStorage.order)
      final ordersListOrError = await getOrdersListForCurrentUser();
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
    } else if (event is SignOutEvent) {
      final signoutResult = await signOutUseCase();
      yield signoutResult.fold(
              (failure) =>
              ErrorHomeState(failure),
              (voidResult) => LoggedOutState());
    }
  }
}
