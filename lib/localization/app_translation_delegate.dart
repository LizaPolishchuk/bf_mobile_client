import 'dart:async';

import 'package:flutter/material.dart';

import 'application.dart';
import 'translations.dart';

class LocalTranslationsDelegate
    extends LocalizationsDelegate<LocalTranslations> {
  final Locale? newLocale;
  final VoidCallback? onLocaleLoaded;

  const LocalTranslationsDelegate(
      {this.newLocale, @required this.onLocaleLoaded})
      : assert(onLocaleLoaded != null);

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<LocalTranslations> load(Locale locale) {
    return LocalTranslations.load(newLocale ?? locale, onLocaleLoaded!);
  }

  @override
  bool shouldReload(LocalizationsDelegate<LocalTranslations> old) {
    return true;
  }
}
