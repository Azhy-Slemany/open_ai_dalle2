import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_ai_dalle2/requests.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class FileOperations {
  static const String DEFAULT_FILE_NAME = 'DALL-E';

  /*static Future<bool> saveImage(String url, String prompt,
      {Directory? path}) async {
    try {
      if (path == null) {
        path = await getApplicationDocumentsDirectory();
      }

      //generate a file name for the image
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      var fileName = '${DEFAULT_FILE_NAME}_${prompt}_$timestamp.png';

      //check if any file with the same name exists
      var file = File(join(path.path, fileName));
      if (await file.exists()) {
        //if it exists, add a number to the end of the file name
        var i = 1;
        while (await file.exists()) {
          fileName = '${DEFAULT_FILE_NAME}_${prompt}_$timestamp($i).png';
          file = File(join(path.path, fileName));
          i++;
        }
      }

      //save the image
      final bytes = await getImageBytes(url);
      await file.writeAsBytes(bytes);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }*/

  static Future<bool> saveImage(String url, String prompt) async {
    //generate a file name for the image
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    var fileName = '${DEFAULT_FILE_NAME}_${prompt}_$timestamp';

    //read the image from the url
    final bytes = await getImageBytes(url);

    //print((await Permission.storage.status).isGranted);

    var result = await ImageGallerySaver.saveImage(Uint8List.fromList(bytes),
        quality: 60, name: fileName);
    //print(result['filePath']);
    return result['isSuccess'];
  }
}
