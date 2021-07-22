import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:salons_app_mobile/utils/locale_constants.dart';

class Application {
  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  String defaultLocaleCode = kEnCodeLocale;
  Locale defaultLocale = Locale(kEnCodeLocale, "");
  LocaleChangeCallback? onLocaleChanged;

  final List<String> supportedLanguages = [
    kEnLocale,
    kRuLocale
    // kFrLocale,
    // kDeLocale,
    // kItLocale,
    // kEsLocale,
  ];

  final List<String> supportedLanguagesCodes = [
    kEnCodeLocale,
    kRuCodeLocale
    // kFrCodeLocale,
    // kDeCodeLocale,
    // kItCodeLocale,
    // kEsCodeLocale,

    // kRuCodeLocale,
  ];

  Iterable<Locale> supportedLocales() => supportedLanguagesCodes
      .map<Locale>((languageCode) => Locale(languageCode, ""));

  ///Decides which locale will be used within the given [updatedDeviceLocaleList]
  Locale resolveLocale({@required List<Locale>? updatedDeviceLocaleList}) {
    if (updatedDeviceLocaleList != null &&
        updatedDeviceLocaleList.isNotEmpty &&
        supportedLanguagesCodes
            .contains(updatedDeviceLocaleList.first.languageCode))
      return updatedDeviceLocaleList.first;
    else
      return Locale(application.defaultLocaleCode, "");
  }
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale);
