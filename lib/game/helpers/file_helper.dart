import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path;

class FileHelper {
  static Future<Directory> getTemporaryDirectory() async {
    return await path.getTemporaryDirectory();
  }

  static Future<File> writeFileAsBytes(
      dynamic byteData, String filePath) async {
    return await File(filePath).writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  static Future<File> getFileFromUrl(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final byteData = response.bodyBytes;
    Directory tempDirectory = await getTemporaryDirectory();
    String tempPath = '${tempDirectory.path}/file.png';
    return await writeFileAsBytes(byteData, tempPath);
  }
}
