import 'package:bf_network_module/bf_network_module.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationsManager {
  static final NotificationsManager _instance = NotificationsManager._internal();

  late RegisterTokenUseCase _registerTokenUseCase;
  late UnregisterTokenUseCase _unregisterTokenUseCase;

  factory NotificationsManager() {
    return _instance;
  }

  NotificationsManager._internal() {
    _registerTokenUseCase = getIt<RegisterTokenUseCase>();
    _unregisterTokenUseCase = getIt<UnregisterTokenUseCase>();
  }

  bindToken(String token) async {
    // Assume user is logged in for this example
    if (FirebaseAuth.instance.currentUser!= null) {
      String authToken = await FirebaseAuth.instance.currentUser!.getIdToken();

      await _registerTokenUseCase(authToken: authToken, pushToken: token);
      debugPrint('Bind push token to current user $token');
    }
  }

  unbindToken() async {
    try {
      String authToken = await FirebaseAuth.instance.currentUser!.getIdToken();
      String? token = await FirebaseMessaging.instance.getToken();
      await _unregisterTokenUseCase(authToken: authToken, pushToken: token!);
      debugPrint('Push token unbound');
    } catch (e) {
      print("unbindToken error: $e");
    }
  }
}
