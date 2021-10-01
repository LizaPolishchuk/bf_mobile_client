import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class ServicesState {}

class InitialServicesListState extends ServicesState {}

class ServicesListLoadedState extends ServicesState {
  final List<Service> services;

  ServicesListLoadedState(this.services);
}

class LoadServicesErrorState extends ServicesState {
    final String errorMessage;

  LoadServicesErrorState(this.errorMessage);
}