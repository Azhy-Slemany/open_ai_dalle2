import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_ai_dalle2/constants.dart' as consts;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key, required this.isDartTheme}) : super(key: key);

  final StreamController<bool> isDartTheme;

  @override
  _SettingsPageState createState() => _SettingsPageState(isDartTheme);
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState(this.isDartTheme);

  final StreamController<bool> isDartTheme;
  bool isDarkMode = consts.isDarkMode;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    loadPreferences();
  }

  loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: consts.whiteOrBlack(),
            ),
            elevation: 0,
            centerTitle: true,
            title: Text('Settings',
                style: TextStyle(color: consts.whiteOrBlack())),
            backgroundColor: Colors.transparent,
          ),
          body: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Dark Mode'),
                trailing: Switch(
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                      consts.isDarkMode = value;
                      isDartTheme.add(value);
                      prefs.setBool(consts.PREFS_THEME_MODE_LIGHT, !value);
                    });
                  },
                  value: isDarkMode,
                ),
              )
            ],
          )),
    );
  }
}
