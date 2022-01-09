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

  int page = 1;
  int limit = 5;
  bool noMoreData = false;

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
      final salonsListOrError = await getSalonsListUseCase(
          searchText: event.searchText,
          page: page,
          limit: limit,
          searchFilters: event.searchFilters);
      _parseSalonsResponse(salonsListOrError);
    }
  }

  void _parseSalonsResponse(Either<Failure, List<Salon>> salonsListOrError) {
    salonsListOrError.fold((failure) {
      salonsStreamSink.addError(failure.message);
    }, (salonsList) {
      print("_parseSalonsResponse ${salonsList.length}, page: $page");
      noMoreData = false;

      if (page == 1) {
        this.salonsList = salonsList;
      } else {
        if (salonsList.length == 0) {
          print("_parseSalonsResponse no more data set tot true");

          noMoreData = true;
        }
        this.salonsList.addAll(salonsList);
      }
      salonsStreamSink.add(this.salonsList);
    });
  }
}
