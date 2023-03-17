import 'package:bf_mobile_client/build_info.dart';
import 'package:bf_mobile_client/utils/notifications/notifications_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint('Handling a background message ${message.messageId}');
}

class FirebasePushNotificationsService {
  static final FirebasePushNotificationsService _singleton =
      FirebasePushNotificationsService._internal();

  static FirebasePushNotificationsService get instance => _singleton;

  FirebasePushNotificationsService._internal();

  Map<String, dynamic>? lastMessageData;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel androidNotificationsChannel;
  late AndroidNotificationChannel androidReactionNotificationsChannel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin localNotifications;

  void init({required Function(AuthorizationStatus) onPermissionAsked}) async {
    final permissionStatus = await _requestNotificationPermission();
    onPermissionAsked(permissionStatus);
    print("init FirebasePushNotificationsService");
    _initTokenHandling();
    await _setupLocalNotifications();
    _initMessagingCallbacks();
  }

  _setupLocalNotifications() async {
    localNotifications = FlutterLocalNotificationsPlugin();

    var androiInit = const AndroidInitializationSettings(
        '@drawable/ic_notifications'); //for logo
    var iosInit = const DarwinInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    // localNotifications.initialize(initSetting);
    localNotifications.initialize(
      initSetting,
      //   onSelectNotification: (details) {
      // print('onDidReceiveNotificationResponse');
      // if (lastMessageData != null) {
      //   _fireNotificationOpenedEvent(lastMessageData!);
      // }
      // }
    );

    /// Create an Android Notification Channel.
    androidNotificationsChannel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.max,
    );

    androidReactionNotificationsChannel = const AndroidNotificationChannel(
        'reactions_channel', // id
        'Reaction Notifications', // title
        description: 'This channel is used for reaction notifications.',
        // description
        importance: Importance.min,
        playSound: false,
        enableVibration: false);

    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    return localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationsChannel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
  }

  Future<AuthorizationStatus> _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    final notificationSettings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return notificationSettings.authorizationStatus;
  }

  Future<void> _initMessagingCallbacks() async {
    IosToFlutterPushNotificationsService.instance
        .addPushNotificationClickedCallback((notificationData) {
      // _fireNotificationOpenedEvent(notificationData);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //remove badge when app is in background state
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      if (await FlutterAppBadger.isAppBadgeSupported()) {
        FlutterAppBadger.removeBadge();
      }
      // _fireNotificationOpenedEvent(event.data);
    });
    //remove badge when app is terminated
    var initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (await FlutterAppBadger.isAppBadgeSupported()) {
        FlutterAppBadger.removeBadge();
      }

      // if (!Platform.isIOS) {
      //   _fireNotificationOpenedEvent(initialMessage.data);
      // }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('puuush onMessage');
      print(message.data);
      RemoteNotification? notification = message.notification;
      debugPrint('Notification Received: ${notification?.title}');
      AndroidNotification? android = message.notification?.android;

      const notificationTypeKey = "NotificationType";
      final isReaction = message.data.containsKey(notificationTypeKey) &&
          message.data[notificationTypeKey] == "reaction";

      lastMessageData = message.data;
      print('lastMessageData');
      print(lastMessageData);

      if (notification != null && android != null && !kIsWeb) {
        localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                isReaction
                    ? androidReactionNotificationsChannel.id
                    : androidNotificationsChannel.id,
                isReaction
                    ? androidReactionNotificationsChannel.name
                    : androidNotificationsChannel.name,
                channelDescription: isReaction
                    ? androidReactionNotificationsChannel.description
                    : androidNotificationsChannel.description,
                importance: isReaction ? Importance.low : Importance.high,
                priority: isReaction ? Priority.low : Priority.high,
                playSound: isReaction ? false : true,
                enableVibration: isReaction ? false : true),
          ),
        );
      }
    });

    return Future.value(null);
  }

  _initTokenHandling() {
    FirebaseMessaging.instance.getToken().then((value) {
      BuildInfo().pushToken = value;
      debugPrint('Push Token: $value');
      return value!;
    }).then(NotificationsManager().bindToken);
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      BuildInfo().pushToken = token;
      await NotificationsManager().bindToken(token);
    });
  }

// _fireNotificationOpenedEvent(Map<String, dynamic> data) {
//   try {
//     print('_fireNoificationOpenedEvent');
//     print(data);
//     String? contentId;
//     NotificationType? notificationType;
//     if (data.containsKey('extra')) {
//       final extraMap = json.decode(data['extra']);
//       contentId = extraMap['content_id'];
//       notificationType = ContentNotificationOpened.typeFromString(extraMap['NotificationType']);
//     } else {
//       contentId = data['content_id'];
//       notificationType = ContentNotificationOpened.typeFromString(data['NotificationType']);
//     }
//
//     if (contentId != null) {
//       eventBus.fire(ContentNotificationOpened(contentId, notificationType));
//     }
//   } catch (e) {
//     debugPrint('notification data parser error $e');
//   }
// }
}

class IosToFlutterPushNotificationsService {
  static final IosToFlutterPushNotificationsService _instance =
      IosToFlutterPushNotificationsService._internal();

  IosToFlutterPushNotificationsService._internal();

  static IosToFlutterPushNotificationsService get instance => _instance;

  static const MethodChannel _channel =
      MethodChannel('native_to_flutter_push_notifications_channel');

  void addPushNotificationClickedCallback(
      void Function(Map<String, dynamic> notificationData) onClickCallback) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "onPushNotificationClick") {
        final args = Map<String, dynamic>.from(call.arguments);
        onClickCallback(args);
      }
    });
  }
}
