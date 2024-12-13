// ignore: depend_on_referenced_packages
import 'dart:io';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  static Reference storageRef = FirebaseStorage.instance.ref();
  FirebaseStorageService._();

  static Reference createReferences(String path) {
    return storageRef.child(path);
  }

  static Future<File?> testCompressAndGetFile(File file) async {
    final directory = dirname(file.path);
    final targetFilePath =
        '$directory/${basenameWithoutExtension(file.path)}_resized${extension(file.path)}';
    final targetFile = File(targetFilePath);
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetFile.path,
      quality: 22,
    );

    return File(result!.path);
  }

  static Future<String?> uploadImageAndGetDownloadFile(File? file) async {
    try {
      if (file != null) {
        final mimeType = lookupMimeType(file.path);
        if (mimeType == null ||
            !(mimeType == 'image/png' || mimeType == 'image/jpeg')) {
          throw Exception('Invalid file type. Only PNG and JPG are allowed.');
        }
        final resizedFile = await testCompressAndGetFile(file);

        if (resizedFile != null) {
          final imageRef =
              await createReferences("image/${HelpersUtils.getToday()}");
          await imageRef.putFile(resizedFile);

          // Return download URL
          return await imageRef.getDownloadURL();
        }

        return "";
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
