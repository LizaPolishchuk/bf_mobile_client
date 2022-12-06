import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart' as di;
import 'package:salons_app_mobile/event_bus_events/event_bus.dart';
import 'package:salons_app_mobile/event_bus_events/user_logout_event.dart';
import 'package:salons_app_mobile/event_bus_events/user_registered_event.dart';
import 'package:salons_app_mobile/event_bus_events/user_success_logged_in_event.dart';
import 'package:salons_app_mobile/localization/app_translation_delegate.dart';
import 'package:salons_app_mobile/localization/application.dart';
import 'package:salons_app_mobile/prezentation/home/home_container.dart';
import 'package:salons_app_mobile/prezentation/login/login_bloc.dart';
import 'package:salons_app_mobile/prezentation/login/login_page.dart';
import 'package:salons_app_mobile/prezentation/navigation/routes.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_page.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

import 'injection_container_app.dart' as appDi;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

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

class _MyAppState extends State<MyApp> {
  late LocalTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();

    _newLocaleDelegate = LocalTranslationsDelegate(
      newLocale: Locale(application.defaultLocaleCode),
      onLocaleLoaded: _onLocaleLoaded,
    );
    application.onLocaleChanged = _onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salons App',
      theme: mainTheme,
      onGenerateRoute: onGenerateRoutes,
      localeListResolutionCallback: (locales, supportedLocales) {
        return application.resolveLocale(updatedDeviceLocaleList: locales);
      },
      localizationsDelegates: [
        _newLocaleDelegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: application.supportedLocales(),
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocaleLanguage in supportedLocales) {
          if (supportedLocaleLanguage.languageCode == locale!.languageCode &&
              supportedLocaleLanguage.countryCode == locale.countryCode) {
            return supportedLocaleLanguage;
          }
        }
        return supportedLocales.first;
      },
      home: InitialPage(),
    );
  }

  void _onLocaleLoaded() {
    // BlocProvider.of<AuthenticationBloc>(context).add(AppStartedEvent());
    // locator<ConnectedAppsDataService>().onChangeLocale();
  }

  void _onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = LocalTranslationsDelegate(
        newLocale: locale,
        onLocaleLoaded: _onLocaleLoaded,
      );
    });
  }
}

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  late LocalTranslationsDelegate _newLocaleDelegate;
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
      setState(() {
        _initialPage = event.isNewUser
            ? RegistrationPage(event.user)
            : const HomeContainer();
      });
    });

    eventBus.on<UserRegisteredEvent>().listen((event) {
      _initialPage = const HomeContainer();
    });

    eventBus.on<UserLoggedOutEvent>().listen((event) {
      setState(() {
        _initialPage = LoginPage();
      });
    });

    _initialPage = (token?.isNotEmpty != true)
        ? LoginPage()
        : (user?.isRegistered != true)
            ? RegistrationPage(user!)
            : HomeContainer();

    if (token != null && user == null) {
      token = null;
      getIt<LoginBloc>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPage,
    );
  }
}
