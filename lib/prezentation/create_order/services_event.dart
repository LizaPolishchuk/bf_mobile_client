import 'package:meta/meta.dart';

@immutable
abstract class ServicesEvent {}

class LoadServicesListEvent extends ServicesEvent {
  final String salonId;
  final String categoryId;

  LoadServicesListEvent(this.salonId,this.categoryId);
}
