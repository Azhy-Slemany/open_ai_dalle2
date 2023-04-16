import 'package:flutter/material.dart';
import 'package:open_ai_dalle2/constants.dart' as consts;

AppBar CustomAppBar(String title) {
  return AppBar(
    iconTheme: IconThemeData(
      color: consts.whiteOrBlack(),
    ),
    elevation: 0,
    centerTitle: true,
    title: Text(title, style: TextStyle(color: consts.whiteOrBlack())),
    backgroundColor: Colors.transparent,
  );
}
