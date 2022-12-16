import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class UserSuccessLoggedInEvent {
  final bool isNewUser;
  final UserEntity user;

  UserSuccessLoggedInEvent(this.isNewUser, this.user);
}
