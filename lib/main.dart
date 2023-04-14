import 'package:flutter/material.dart';
import 'package:open_ai_dalle2/image.dart';
import 'package:open_ai_dalle2/pages/image_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //precache all the images
    Images.precacheImages(context);

    return MaterialApp(
      title: 'Image Generator',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        textTheme: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.black, displayColor: Colors.black),
        backgroundColor: Color.fromRGBO(253, 252, 250, 1),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Color.fromRGBO(35, 35, 35, 1),
      ),
      themeMode: ThemeMode.dark,
      home: ImageGenerator(),
      debugShowCheckedModeBanner: false,
    );
  }
}
