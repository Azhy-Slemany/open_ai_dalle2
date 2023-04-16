import 'package:flutter/material.dart';

bool isDarkMode = true;
String language = 'ku';

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

const KEYS = [
  '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',
  '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',
  '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',
  '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',
  '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'
];

const PREFS_THEME_MODE_LIGHT = 'themeMode';
const PREFS_LANGUAGE = 'language';
