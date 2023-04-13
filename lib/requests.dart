import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:open_ai_dalle2/constants.dart';
import 'package:open_ai_dalle2/models/generated_image.dart';

Future<GeneratedImage> generateImage(String prompt,
    {int n = 1, String size = '1024x1024', keyIndex = 0}) async {
  var response = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Authorization': 'Bearer ${KEYS[keyIndex]}',
        "Content-Type": "application/json"
      },
      body: jsonEncode({'prompt': prompt, 'n': n, 'size': size}),
      encoding: Encoding.getByName('utf-8'));

  var result = jsonDecode(response.body);

  return GeneratedImage.fromJson(result);

  /*if (response.statusCode == 200) {
    print('Success');
    return GeneratedImage.fromJson(result);
  } else if (response.statusCode == 400) {
    print('Failed');
    if (result['error']['code'] == 'billing_hard_limit_reached') {
      return GeneratedImage.fromJson(result);
    }
  }*/
}

Future<GeneratedImage> generateImageForTest(int n) {
  return Future.delayed(
      Duration(seconds: 2),
      () => GeneratedImage(
          images: [
            'https://wallpaperaccess.com/full/1139003.jpg',
            'https://www.solidbackgrounds.com/images/1024x1024/1024x1024-light-blue-solid-color-background.jpg',
            'https://4kwallpapers.com/images/wallpapers/colorful-background-texture-multi-color-orange-illustration-1024x1024-3104.jpg',
            'https://external-preview.redd.it/2dl76P1oLNL7k80c9d2lJJ1uW77ieSU9c2lj5MNZ1LE.png?auto=webp&s=c0d1a8bf61817e1d58d78f98e4daa72bd27c5850',
            'https://wallpaperaccess.com/full/3124550.jpg',
            'https://upload.wikimedia.org/wikipedia/commons/c/c1/Icon_Skull_1024x1024.png',
            'https://cdn.wallpapersafari.com/20/97/5OL9zM.jpg',
            'https://wallpaperaccess.com/full/2252421.jpg',
            'https://wallpapercave.com/wp/wp4471360.jpg',
            'https://wallpaperaccess.com/full/1138973.jpg'
          ].sublist(0, n),
          isCreated: true));
}

Future<Uint8List> getImageBytes(String url) async {
  var response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}
