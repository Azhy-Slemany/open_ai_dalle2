import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_ai_dalle2/constants.dart';
import 'package:open_ai_dalle2/image.dart';
import 'package:open_ai_dalle2/pages/home.dart';
import 'package:open_ai_dalle2/pages/image_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

StreamController<bool> isDartTheme = StreamController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //get shared preferences
  var prefs = await SharedPreferences.getInstance();

  //get the theme mode
  if (prefs.containsKey(PREFS_THEME_MODE_LIGHT)) {
    isDarkMode = prefs.getBool(PREFS_THEME_MODE_LIGHT)!;
  } else {
    //you can get the system theme mode here
    prefs.setBool(PREFS_THEME_MODE_LIGHT, true);
    isDarkMode = false;
  }
  isDartTheme.add(isDarkMode);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //precache all the images
    Images.precacheImages(context);

    return StreamBuilder<bool>(
        initialData: isDarkMode,
        stream: isDartTheme.stream,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Image Generator',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.indigo,
              backgroundColor: Color.fromRGBO(253, 252, 250, 1),
            ),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                backgroundColor: Color.fromRGBO(35, 35, 35, 1),
                indicatorColor: Colors.white),
            themeMode: snapshot.data! ? ThemeMode.dark : ThemeMode.light,
            home: HomePage(isDartTheme: isDartTheme),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
