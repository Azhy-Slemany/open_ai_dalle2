import 'package:flutter/material.dart';

bool isDarkMode = true;
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
  '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'
];

const PREFS_THEME_MODE_LIGHT = 'themeMode';
