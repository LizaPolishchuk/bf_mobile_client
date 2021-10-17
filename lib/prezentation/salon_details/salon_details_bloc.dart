import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import 'salon_details_event.dart';
import 'salon_details_state.dart';

class SalonDetailsBloc extends Bloc<SalonDetailsEvent, SalonDetailsState> {
  final GetSalonByIdUseCase getSalonByIdUseCase;

  SalonDetailsBloc(this.getSalonByIdUseCase) : super(InitialSalonDetailsState());

  @override
  Stream<SalonDetailsState> mapEventToState(
    SalonDetailsEvent event,
  ) async* {
    if (event is LoadSalonByIdEvent) {
      yield LoadingSalonDetailsState();

      final salonOrError = await getSalonByIdUseCase(event.salonId);

      yield salonOrError.fold((failure) {
        return ErrorSalonDetailsState(failure);
      }, (salon) {
        return SalonDetailsLoadedState(salon);
      });
    }
  }
}
