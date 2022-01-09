import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import 'search_filters_event.dart';
import 'search_filters_state.dart';

class SearchFiltersBloc extends Bloc<SearchFiltersEvent, SearchFiltersState> {
  final GetFiltersUseCase getFiltersUseCase;

  SearchFiltersBloc(
    this.getFiltersUseCase,
  ) : super(InitialFiltersState());

  @override
  Stream<SearchFiltersState> mapEventToState(
    SearchFiltersEvent event,
  ) async* {
    if (event is LoadFiltersEvent) {
      final filtersListOrError = await getFiltersUseCase();

      yield filtersListOrError.fold((failure) => ErrorFiltersState(failure),
          (filters) => FiltersLoadedState(filters));
    }
  }
}
