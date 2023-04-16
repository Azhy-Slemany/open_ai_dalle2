import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_kurdish_localization/flutter_kurdish_localization.dart';
//import 'package:flutter_kurdish_localization/flutter_kurdish_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:open_ai_dalle2/constants.dart';
import 'package:open_ai_dalle2/image.dart';
import 'package:open_ai_dalle2/pages/home.dart';
import 'package:open_ai_dalle2/pages/image_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

StreamController<String> streamController = StreamController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //get shared preferences
  var prefs = await SharedPreferences.getInstance();

  //get the theme mode
  if (prefs.containsKey(PREFS_THEME_MODE_LIGHT)) {
    isDarkMode = !prefs.getBool(PREFS_THEME_MODE_LIGHT)!;
  } else {
    //you can get the system theme mode here
    prefs.setBool(PREFS_THEME_MODE_LIGHT, true);
    isDarkMode = false;
  }

  //get the language
  if (prefs.containsKey(PREFS_LANGUAGE)) {
    language = prefs.getString(PREFS_LANGUAGE)!;
  } else {
    //you can get the system language here
    prefs.setString(PREFS_LANGUAGE, 'ku');
    language = 'ku';
  }

  streamController.add(makeStreamValue());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //precache all the images
    Images.precacheImages(context);

    return StreamBuilder<String>(
        initialData: makeStreamValue(),
        stream: streamController.stream,
        builder: (context, snapshot) {
          Map<String, dynamic> result = splitStreamValue(snapshot.data!);
          bool isDartTheme = result['theme'];
          String language = result['lang'];

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
            themeMode: isDartTheme ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: [
              AppLocalizations.delegate,
              KurdishMaterialLocalizations.delegate,
              KurdishWidgetLocalizations.delegate,
              KurdishCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('ku'),
            ],
            locale: Locale(language),
            home: HomePage(streamController: streamController),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
