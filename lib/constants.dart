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
    "c2stbUVyeVRWY01Kd21yTHBhNmwzY2pUM0JsYmtGSmhSNXN2ZWV3MkhlZUszdUdCdDdTc2staU5NQ0tFZEo5aXBndXpxVnhxSHhUM0JsYmtGSmNtdmVEMnBkVEJqMWZZc2Zva3Jpc2stc2V0MEhGQ2pHQndWczZHRFVWRk9UM0JsYmtGSkZRVWFHTDh6cGNNOVhMRDNmS0N6c2stdlZWOVFwQVdyVkVwT3VlMDlWTnZUM0JsYmtGSjBlbWxmb3dDTldDUWVGOXZFbkNsc2stY3JZV1NzVk80YWZpN29ET1FmQjZUM0JsYmtGSllmcW01aUw1enNybmg1d1BNdE1S";
const KEY_LENGTH = 51;

String decodeString(String input) {
  return utf8.decode(base64Decode(input));
}

List<String> KEYS = [];

const PREFS_THEME_MODE_LIGHT = 'themeMode';
const PREFS_LANGUAGE = 'language';
