import 'dart:convert';

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
    return errorMessage;
  }
}

const KEYS_ENCODED =
    "c2sta0ZBU2pwZVNIbnRUVGpmWkZBOEpUM0JsYmtGSmNtSHBqb3NYMFpKNUVEYjl4c3NPc2stbmdvMVM2Z1VzVUJwamtGMXJ4bEpUM0JsYmtGSlZXSXhlSzJ3WDhhWTFmdXdGdjdr";
const KEY_LENGTH = 51;

String decodeString(String input) {
  return utf8.decode(base64Decode(input));
}

List<String> KEYS = [];

const PREFS_THEME_MODE_LIGHT = 'themeMode';
const PREFS_LANGUAGE = 'language';
