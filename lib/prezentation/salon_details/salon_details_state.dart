import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class SalonDetailsState {}

class InitialSalonDetailsState extends SalonDetailsState {}
class LoadingSalonDetailsState extends SalonDetailsState {}

class SalonDetailsLoadedState extends SalonDetailsState {
  final Salon salon;

  SalonDetailsLoadedState(this.salon);
}

class ErrorSalonDetailsState extends SalonDetailsState {
  final Failure failure;

  ErrorSalonDetailsState(this.failure);
}
