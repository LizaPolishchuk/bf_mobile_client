import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import 'salons_event.dart';
import 'salons_state.dart';

class SalonsBloc extends Bloc<SalonsEvent, SalonsState> {
  final GetSalonsListUseCase getSalonsListUseCase;

  SalonsBloc(
    this.getSalonsListUseCase,
  ) : super(InitialSalonsState()) {
    streamController = StreamController<List<Salon>>.broadcast();
  }

  List<Salon> salonsList = [];

  late StreamController<List<Salon>> streamController;

  StreamSink<List<Salon>> get salonsStreamSink => streamController.sink;

  Stream<List<Salon>> get streamSalons => streamController.stream;

  void dispose() {
    streamController.close();
  }

  @override
  Stream<SalonsState> mapEventToState(
    SalonsEvent event,
  ) async* {
    if (event is LoadTopSalonsEvent) {
      final salonsListOrError = await getSalonsListUseCase(loadTop: true);
      salonsListOrError.fold((failure) {
        salonsStreamSink.addError(failure.message);
      }, (ordersList) {
        this.salonsList = ordersList;
        salonsStreamSink.add(ordersList);
      });
    } else if (event is SearchSalonsEvent) {}
  }
}
