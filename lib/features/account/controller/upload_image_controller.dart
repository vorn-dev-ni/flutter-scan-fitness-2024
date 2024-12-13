// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/data/service/firebase_storage_service.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';

class UploadImageController {
  late WidgetRef ref;
  UploadImageController({
    required this.ref,
  });

  Future<String?> uploadFile(File? file) async {
    try {
      bool? isExisted =
          await FirestoreService(firebaseAuthService: FirebaseAuthService())
              .checkUserImage();

      String? downloadUrl =
          await FirebaseStorageService.uploadImageAndGetDownloadFile(file);
      print("Downloaded Url is ${downloadUrl}");
      if (downloadUrl != null) {
        kDebugMode ? print("Downloaded Url is ${downloadUrl}") : null;
        await LocalStorageUtils().setKeyString('avatarImage', downloadUrl);
        return downloadUrl;
      }
    } catch (e) {
      ref.read(appLoadingStateProvider.notifier).setState(false);
      HelpersUtils.showErrorSnackbar(
          ref.context, "Upload Failed", e.toString(), StatusSnackbar.failed);

      rethrow;
    }
    return "";
  }
}
