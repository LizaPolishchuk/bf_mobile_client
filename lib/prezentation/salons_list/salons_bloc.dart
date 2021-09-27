import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
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
      _parseSalonsResponse(salonsListOrError);
    } else if (event is LoadSalonsEvent) {
      final salonsListOrError = await getSalonsListUseCase(searchText: event.searchText);
      _parseSalonsResponse(salonsListOrError);
    }
  }


  void _parseSalonsResponse(Either<Failure, List<Salon>> salonsListOrError){
    salonsListOrError.fold((failure) {
      salonsStreamSink.addError(failure.message);
    }, (ordersList) {
      this.salonsList = ordersList;
      salonsStreamSink.add(ordersList);
    });
  }
}
