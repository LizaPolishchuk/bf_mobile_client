import 'package:meta/meta.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

@immutable
abstract class RegistrationEvent {}

class UpdateUserEvent extends RegistrationEvent {
  final UserEntity user;

  UpdateUserEvent(this.user);
}
