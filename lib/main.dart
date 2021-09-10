import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart' as di;
import 'package:salons_app_mobile/localization/app_translation_delegate.dart';
import 'package:salons_app_mobile/localization/application.dart';
import 'package:salons_app_mobile/prezentation/login/code_verification_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: Hive.box(LocalStorage.preferencesBox).listenable(),
          builder: (BuildContext context, Box<dynamic> box, Widget? child) {
            String token = box.get(LocalStorage.accessToken, defaultValue: "");
            if (token.isNotEmpty) {
              return RegistrationPage();
            } else {
              return CodeVerificationPage();
            }
          }),
    );
  }
}
