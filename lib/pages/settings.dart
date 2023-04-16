import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_ai_dalle2/constants.dart' as consts;
import 'package:open_ai_dalle2/custom_widgets.dart';
import 'package:open_ai_dalle2/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key, required this.streamController}) : super(key: key);

  final StreamController<String> streamController;

  @override
  _SettingsPageState createState() => _SettingsPageState(streamController);
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState(this.streamController);

  final StreamController<String> streamController;
  bool isDarkMode = consts.isDarkMode;
  late SharedPreferences prefs;
  final Map<String, String> languages = {'English': 'en', 'کوردی': 'ku'};
  late String currentLanguage;

  @override
  void initState() {
    super.initState();

    loadPreferences();
    currentLanguage = consts.language;
  }

  loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: CustomAppBar(AppLocalizations.of(context)!.settings),
        body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text(AppLocalizations.of(context)!.darkMode),
              trailing: Switch(
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                    consts.isDarkMode = value;
                    prefs.setBool(consts.PREFS_THEME_MODE_LIGHT, !value);
                    streamController.add(consts.makeStreamValue());
                  });
                },
                value: isDarkMode,
              ),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.language),
              trailing: DropdownButton<String>(
                value: currentLanguage,
                items: languages
                    .map((key, value) => MapEntry(
                        key, DropdownMenuItem(child: Text(key), value: value)))
                    .values
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    currentLanguage = value!;
                  });
                  consts.language = value!;
                  prefs.setString(consts.PREFS_LANGUAGE, value);
                  streamController.add(consts.makeStreamValue());
                },
              ),
            ),
          ],
        ));
  }
}
