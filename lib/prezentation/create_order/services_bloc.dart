import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/create_order/services_event.dart';
import 'package:salons_app_mobile/prezentation/create_order/services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final GetServicesListUseCase getServicesListUseCase;

  List<Service> serviceList = [];

  ServicesBloc(this.getServicesListUseCase)
      : super(InitialServicesListState()) {
    streamController = StreamController<List<Service>>.broadcast();
  }

  void dispose() {
    streamController.close();
  }

  late StreamController<List<Service>> streamController;

  StreamSink<List<Service>> get streamSink => streamController.sink;

  Stream<List<Service>> get streamServices => streamController.stream;

  @override
  Stream<ServicesState> mapEventToState(
    ServicesEvent event,
  ) async* {
    if (event is LoadServicesListEvent) {
      final servicesListOrError = await getServicesListUseCase(event.salonId, event.categoryId);
      servicesListOrError.fold((failure) {
        streamSink.addError(failure.message);
      }, (serviceList) {
        this.serviceList = serviceList;
        streamSink.add(serviceList);
      });
    }
  }
}
