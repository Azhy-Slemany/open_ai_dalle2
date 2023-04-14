import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:open_ai_dalle2/constants.dart' as consts;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:open_ai_dalle2/pages/image_generator.dart';
import 'package:open_ai_dalle2/pages/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.isDartTheme}) : super(key: key);

  final StreamController<bool> isDartTheme;

  @override
  State<HomePage> createState() => _HomePageState(isDartTheme);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.isDartTheme);

  final StreamController<bool> isDartTheme;
  ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ZoomDrawer(
        style: DrawerStyle.defaultStyle,
        controller: _drawerController,
        borderRadius: 24.0,
        showShadow: true,
        menuBackgroundColor: consts.menuBackgroundColor(),
        angle: 0,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
        mainScreen: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  color: consts.whiteOrBlack(),
                  onPressed: () => _drawerController.toggle!(),
                ),
                title: Text('DALL-E 2',
                    style: TextStyle(color: consts.whiteOrBlack())),
                backgroundColor: Colors.transparent,
                elevation: 0.0),
            backgroundColor: Theme.of(context).backgroundColor,
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      'Welcome to DALLE-2 Image generation for mobile, in this application you can generate up to 10 images easily.'),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImageGenerator(),
                      ));
                    },
                    child: Text('Start generating'))
              ],
            )),
        menuScreen: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            SizedBox(height: 100),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                _drawerController.toggle!();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage(isDartTheme: isDartTheme)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
