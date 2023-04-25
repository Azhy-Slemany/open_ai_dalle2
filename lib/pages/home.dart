import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:open_ai_dalle2/constants.dart' as consts;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:open_ai_dalle2/main.dart';
import 'package:open_ai_dalle2/pages/about.dart';
import 'package:open_ai_dalle2/pages/image_editor.dart';
import 'package:open_ai_dalle2/pages/image_generator.dart';
import 'package:open_ai_dalle2/pages/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_ai_dalle2/pages/variation_generator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.streamController}) : super(key: key);

  final StreamController<String> streamController;

  @override
  State<HomePage> createState() => _HomePageState(streamController);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.streamController);

  final StreamController<String> streamController;
  ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.defaultStyle,
      controller: _drawerController,
      borderRadius: 24.0,
      showShadow: true,
      isRtl: consts.language != 'en',
      menuBackgroundColor: consts.menuBackgroundColor(),
      angle: 0,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      openCurve: Curves.easeOut,
      closeCurve: Curves.bounceIn,
      mainScreen: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.menu),
                color: consts.whiteOrBlack(),
                onPressed: () => _drawerController.toggle!(),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Image(
                    image: AssetImage('assets/images/ic_launcher.png'),
                    width: 30,
                    height: 30,
                    color: consts.whiteOrBlack(),
                  ),
                ),
              ],
              title: Text('DALL-E 2',
                  style: TextStyle(color: consts.whiteOrBlack())),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          backgroundColor: Theme.of(context).backgroundColor,
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text(AppLocalizations.of(context)!.welcomeText),
              ),
              Card(
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(AppLocalizations.of(context)!
                          .imageGeneratorShortText),
                    ),
                    Container(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageGenerator(),
                            ));
                          },
                          child: Text(
                              AppLocalizations.of(context)!.imageGenerator)),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          AppLocalizations.of(context)!.imageEditorShortText),
                    ),
                    Container(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageEditor(),
                            ));
                          },
                          child:
                              Text(AppLocalizations.of(context)!.imageEditor)),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(AppLocalizations.of(context)!
                          .variationsGeneratorShortText),
                    ),
                    Container(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VariationGenerator(),
                            ));
                          },
                          child: Text(AppLocalizations.of(context)!
                              .variationsGenerator)),
                    ),
                  ],
                ),
              ),
            ],
          )),
      menuScreen: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          SizedBox(height: 100),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.home),
            onTap: () {
              _drawerController.toggle!();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      SettingsPage(streamController: streamController)));
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(AppLocalizations.of(context)!.about),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutPage()));
            },
          ),
        ],
      ),
    );
  }
}
