import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/firebase_storage_service.dart';
import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'firestore_controller.g.dart';

@riverpod
class FirestoreController extends _$FirestoreController {
  @override
  dynamic build() {
    return null;
  }

  Future<void> syncActivity(searchTitle, imageFile, ActivityTag type) async {
    FirebaseAuthService firebaseAuthService = FirebaseAuthService();
    print("Call firestore now >>>>>>");

    try {
      if (searchTitle != null && imageFile != null) {
        //Call firebase storage and firebase
        String title = searchTitle;
        String tag = type.name.toString();
        String? downloadUrl =
            await FirebaseStorageService.uploadImageAndGetDownloadFile(
                imageFile);
        String userId = firebaseAuthService.currentUser?.uid ?? "";
        final docId =
            await FirestoreService(firebaseAuthService: firebaseAuthService)
                .addDocument('activities', {
          'title': title,
          'tag': tag,
          'imageUrl': downloadUrl ?? "",
          'userId': userId,
          'created_at': FieldValue.serverTimestamp()
        });
        print("Successfully added >>>>  ${docId}");
      }
    } catch (e) {
      kDebugMode ? print(" _syncFirebase Error caught ${e}") : null;
    }
  }
}
