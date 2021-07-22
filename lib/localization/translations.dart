import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:salons_app_mobile/localization/application.dart';

String tr(String key) => LocalTranslations._translate(key);

class LocalTranslations {
  static LocalTranslations currentAppTranslations = LocalTranslations(application.defaultLocale);

  static LocalTranslations of(BuildContext context) {
    return Localizations.of<LocalTranslations>(context, LocalTranslations)!;
  }

  static Future<LocalTranslations> load(
      Locale locale, VoidCallback onLoaded) async {
    currentLocaleCode = locale.languageCode;

    currentAppTranslations = LocalTranslations(locale);

    final jsonContent = await rootBundle
        .loadString("localizations/localization_${locale.languageCode}.json");
    _localisedValues = json.decode(jsonContent);
    onLoaded();

    return currentAppTranslations;
  }

  late Locale locale;
  static late Map<dynamic, dynamic> _localisedValues;

  static Map<String, dynamic> get localisedValues => _localisedValues as Map<String, dynamic>;
  static String currentLocaleCode = application.defaultLocaleCode;

  LocalTranslations(this.locale);

  get currentLanguage => locale.languageCode;

  static String _translate(String key) {
    return _localisedValues[key] ?? "$key not found";
  }
}
