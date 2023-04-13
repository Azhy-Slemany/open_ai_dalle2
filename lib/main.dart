import 'package:flutter/material.dart';
import 'package:open_ai_dalle2/image.dart';
import 'package:open_ai_dalle2/pages/image_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //precache all the images
    Images.precacheImages(context);

    return MaterialApp(
      title: 'Image Generator',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: ImageGenerator(),
      debugShowCheckedModeBanner: false,
    );
  }
}
