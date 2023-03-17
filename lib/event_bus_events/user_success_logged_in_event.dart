import 'package:bf_network_module/bf_network_module.dart';

class UserSuccessLoggedInEvent {
  final bool isNewUser;
  final UserEntity user;

  UserSuccessLoggedInEvent(this.isNewUser, this.user);
}
