import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:open_ai_dalle2/constants.dart';
import 'package:open_ai_dalle2/models/generated_image.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  var result = handleResponseResult(response);
  if (result.error == 'Incorrect API key' ||
      result.error == 'Billing hard limit reached') {
    if (keyIndexToUse < KEYS.length - 1) {
      keyIndexToUse++;
      return generateImage(prompt, n: n, size: size, keyIndex: keyIndexToUse);
    } else {
      keyIndexToUse = 0;
      return GeneratedImage(
          images: [],
          isCreated: false,
          error: 'Unfortunately, keys are expired');
    }
  }
  return result;
}

Future<GeneratedImage> generateEditedImage(String prompt, XFile image,
    {String? mask, int n = 1, String size = '1024x1024', keyIndex = 0}) async {
  var body = {
    'prompt': prompt,
    'image': image.path,
    'n': n.toString(),
    'size': size
  };
  if (mask != null) {
    body['mask'] = mask;
  }

  var request = http.MultipartRequest(
      'POST', Uri.parse('https://api.openai.com/v1/images/edits'));
  request.fields.addAll(body);

  var imageBytes = http.MultipartFile.fromBytes(
    'image',
    await image.readAsBytes(),
    filename: image.path.split('/').last,
  );
  request.files.add(imageBytes);

  request.headers.addAll({
    'Authorization': 'Bearer ${KEYS[keyIndex]}',
    "Content-Type": "application/json"
  });

  var requestResult = await request.send();
  var response = await http.Response.fromStream(requestResult);

  var result = handleResponseResult(response);
  if (result.error == 'Incorrect API key' ||
      result.error == 'Billing hard limit reached') {
    if (keyIndexToUse < KEYS.length - 1) {
      keyIndexToUse++;
      return generateEditedImage(prompt, image,
          mask: mask, n: n, size: size, keyIndex: keyIndexToUse);
    } else {
      keyIndexToUse = 0;
      return GeneratedImage(
          images: [],
          isCreated: false,
          error: 'Unfortunately, keys are expired');
    }
  }
  return result;
}

Future<GeneratedImage> generateImageVariations(XFile image,
    {String? mask, int n = 1, String size = '1024x1024', keyIndex = 0}) async {
  var body = {'image': image.path, 'n': n.toString(), 'size': size};
  if (mask != null) {
    body['mask'] = mask;
  }

  var request = http.MultipartRequest(
      'POST', Uri.parse('https://api.openai.com/v1/images/variations'));
  request.fields.addAll(body);

  var imageBytes = http.MultipartFile.fromBytes(
    'image',
    await image.readAsBytes(),
    filename: image.path.split('/').last,
  );
  request.files.add(imageBytes);

  request.headers.addAll({
    'Authorization': 'Bearer ${KEYS[keyIndex]}',
    "Content-Type": "application/json"
  });

  var requestResult = await request.send();
  var response = await http.Response.fromStream(requestResult);

  var result = handleResponseResult(response);
  if (result.error == 'Incorrect API key' ||
      result.error == 'Billing hard limit reached') {
    if (keyIndexToUse < KEYS.length - 1) {
      keyIndexToUse++;
      return generateImageVariations(image,
          mask: mask, n: n, size: size, keyIndex: keyIndexToUse);
    } else {
      keyIndexToUse = 0;
      return GeneratedImage(
          images: [],
          isCreated: false,
          error: 'Unfortunately, keys are expired');
    }
  }
  return result;
}

GeneratedImage handleResponseResult(http.Response response) {
  var result = jsonDecode(response.body);

  if (!(result as Map<String, dynamic>).containsKey('error'))
    return GeneratedImage.fromJson(result);

  var errorCode = result['error']['code'];
  var errorMessage = result['error']['message'];

  if (response.statusCode == 200) return GeneratedImage.fromJson(result);
  if (errorCode == 'invalid_api_key')
    errorMessage = 'Incorrect API key';
  else if (errorCode == 'billing_hard_limit_reached')
    errorMessage = 'Billing hard limit reached';
  else if (errorCode == 'rate_limit_exceeded')
    errorMessage = 'Choose a smaller amount of images';

  return GeneratedImage(images: [], isCreated: false, error: errorMessage);
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
