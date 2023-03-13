import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ErrorParser {
  static final ErrorParser _singleton = ErrorParser._internal();

  static late AppLocalizations _appLocalizations;

  factory ErrorParser() {
    return _singleton;
  }

  ErrorParser._internal();

  void updateLocale(Locale locale) async {
    var languageCode = locale.languageCode;
    if (languageCode.contains("-")) {
      languageCode = languageCode.split("-").first;
    } else if (languageCode.contains("_")) {
      languageCode = languageCode.split("_").first;
    }

    _appLocalizations = await AppLocalizations.delegate.load(Locale(languageCode));
  }

  static String parseError(error) {
    if (error is NoInternetException) {
      return _appLocalizations.noInternetConnection;
    }
    if (error is DioError) {
      var detailMessage = error.response?.data["detail"];
      if (detailMessage != null && detailMessage.runtimeType == String) {
        debugPrint("DioError detail: $detailMessage");
        return detailMessage;
      } else {
        debugPrint("DioError message: $detailMessage");
        return error.message;
      }
    } else {
      debugPrint("Error: $error");
      return _appLocalizations.somethingWentWrong;
    }
  }
}
