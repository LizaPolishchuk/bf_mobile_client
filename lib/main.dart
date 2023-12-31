import 'dart:io';

import 'package:bf_mobile_client/event_bus_events/event_bus.dart';
import 'package:bf_mobile_client/event_bus_events/user_done_onboarding_event.dart';
import 'package:bf_mobile_client/event_bus_events/user_logout_event.dart';
import 'package:bf_mobile_client/event_bus_events/user_registered_event.dart';
import 'package:bf_mobile_client/event_bus_events/user_success_logged_in_event.dart';
import 'package:bf_mobile_client/l10n/l10n.dart';
import 'package:bf_mobile_client/prezentation/home/home_container.dart';
import 'package:bf_mobile_client/prezentation/login/login_bloc.dart';
import 'package:bf_mobile_client/prezentation/login/login_page.dart';
import 'package:bf_mobile_client/prezentation/navigation/routes.dart';
import 'package:bf_mobile_client/prezentation/onboarding/onboarding_page.dart';
import 'package:bf_mobile_client/prezentation/registration/registration_page.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:bf_mobile_client/utils/master_mode.dart';
import 'package:bf_mobile_client/utils/notifications/firebase_push_notifications_service.dart';
import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_network_module/bf_network_module.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'injection_container_app.dart' as appDi;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  if (await FlutterAppBadger.isAppBadgeSupported()) {
    FlutterAppBadger.removeBadge();
  }

  await di.init();
  await appDi.init();

  await initHive();

  runApp(MyApp());
}

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(SalonAdapter());
  Hive.registerAdapter(MasterAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(OrderEntityAdapter());
  Hive.registerAdapter(UserEntityAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await getIt<LocalStorage>().openBox();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//test

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // FirebaseInstallations.id.then((value) {
    //   BuildInfo().firebaseInstallationId = value;
    //   debugPrint('Firebase installation id: $value');
    // });
    FirebasePushNotificationsService.instance.init(
        onPermissionAsked: (permissionStatus) {
      // AppAnalytics.instance.init();
      // AppAnalytics.instance.setUserId(BuildInfo().firebaseUserId);
    });
    // FirebaseInAppMessaging _ = FirebaseInAppMessaging.instance;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MasterMode>(
      create: (context) =>
          MasterMode(isMaster: getIt<LocalStorage>().isMasterMode),
      child: ValueListenableBuilder(
          valueListenable: Hive.box(LocalStorage.preferencesBox).listenable(),
          builder: (BuildContext context, Box<dynamic> box, Widget? child) {
            final String defaultSystemLocale = Platform.localeName;
            var locale = Locale(box.get(LocalStorage.currentLanguage,defaultValue: defaultSystemLocale));
            debugPrint(
                "defaultSystemLocale: $defaultSystemLocale, currentLanguage: $locale");

            return MaterialApp(
              title: 'Salons App',
              theme: mainTheme,
              onGenerateRoute: onGenerateRoutes,
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                LocaleNamesLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: L10n.supportedLocales,
              // localeResolutionCallback: (locale, supportedLocales) {
              //   for (var supportedLocaleLanguage in supportedLocales) {
              //     if (supportedLocaleLanguage.languageCode == locale!.languageCode &&
              //         supportedLocaleLanguage.countryCode == locale.countryCode) {
              //       return supportedLocaleLanguage;
              //     }
              //   }
              //   return supportedLocales.first;
              // },
              // localeListResolutionCallback: (locales, supportedLocales) {
              //   return application.resolveLocale(updatedDeviceLocaleList: locales);
              // },
              home: InitialPage(),
            );
          }),
    );
  }

// void _onLocaleLoaded() {
//   // BlocProvider.of<AuthenticationBloc>(context).add(AppStartedEvent());
//   // locator<ConnectedAppsDataService>().onChangeLocale();
// }
//
// void _onLocaleChange(Locale locale) {
//   setState(() {
//     _newLocaleDelegate = LocalTranslationsDelegate(
//       newLocale: locale,
//       onLocaleLoaded: _onLocaleLoaded,
//     );
//   });
// }
}

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String? token;
  UserEntity? user;
  late Widget _initialPage;

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getIt<LocalStorage>();

    user = localStorage.getCurrentUser();
    token = localStorage.getAccessToken();

    print(
        "Main: user: $user, token: $token, isRegistered: ${user?.isRegistered}");

    eventBus.on<UserSuccessLoggedInEvent>().listen((event) {
      print("UserSuccessLoggedInEvent: $event");

      setState(() {
        _initialPage = event.isNewUser
            ? RegistrationPage(event.user)
            : const HomeContainer();
      });
    });

    eventBus.on<UserRegisteredEvent>().listen((event) {
      _initialPage = const OnboardingPage();
    });

    eventBus.on<UserDoneOnboardingEvent>().listen((event) {
      print("UserDoneOnboardingEvent");
      _initialPage = const HomeContainer();
    });

    eventBus.on<UserLoggedOutEvent>().listen((event) {
      print("UserLoggedOutEvent: $event");

      setState(() {
        _initialPage = LoginPage();
      });
    });

    if (token != null && user == null) {
      token = null;
      getIt<LoginBloc>().logout();
    }

    _initialPage = (token == null || token!.isEmpty || user == null)
        ? LoginPage()
        : (user?.isRegistered != true)
            ? RegistrationPage(user!)
            : HomeContainer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPage,
    );
  }
}
