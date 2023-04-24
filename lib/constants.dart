import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool isDarkMode = true;
String language = 'ku';
int keyIndexToUse = 0;

String makeStreamValue() {
  return 'theme=' + isDarkMode.toString() + ';lang=' + language;
}

Map<String, dynamic> splitStreamValue(String value) {
  var theme = value.split(';')[0].split('=')[1] == 'true';
  var lang = value.split(';')[1].split('=')[1];
  return {'theme': theme, 'lang': lang};
}

Color whiteOrBlack() {
  return isDarkMode ? Colors.white : Colors.black;
}

Color menuBackgroundColor() {
  return isDarkMode
      ? Color.fromRGBO(40, 40, 40, 1)
      : Color.fromRGBO(240, 240, 240, 1);
}

String translateErrorMessage(String errorMessage, BuildContext context) {
  if (errorMessage == 'Incorrect API key') {
    return AppLocalizations.of(context)!.incorrect_api_key;
  } else if (errorMessage == 'Billing hard limit reached') {
    return AppLocalizations.of(context)!.billing_hard_limit_reached;
  } else if (errorMessage == 'Choose a smaller amount of images') {
    return AppLocalizations.of(context)!.rate_limit_exceeded;
  } else if (errorMessage == 'Engine is overloaded') {
    return AppLocalizations.of(context)!.engine_is_overloaded;
  } else {
    return AppLocalizations.of(context)!.unknown_error;
  }
}

const KEYS = [
  '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',
  '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',
  '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',
  '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',
  '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'
];

const PREFS_THEME_MODE_LIGHT = 'themeMode';
const PREFS_LANGUAGE = 'language';
