import 'package:meta/meta.dart';

@immutable
abstract class SalonDetailsEvent {}

class InitialSalonDetailsEvent extends SalonDetailsEvent {}

class LoadSalonByIdEvent extends SalonDetailsEvent {
  final String salonId;

  LoadSalonByIdEvent(this.salonId);
}
