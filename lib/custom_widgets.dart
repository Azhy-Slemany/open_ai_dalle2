import 'package:flutter/material.dart';

AppBar CustomAppBar(String title, bool isDarkMode, BuildContext context) {
  return AppBar(
    centerTitle: true,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    title: Text(title.length > 20 ? title.substring(0, 20) + '...' : title,
        style: TextStyle(color: Colors.black)),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
  );
}
