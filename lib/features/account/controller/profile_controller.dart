// ignore_for_file: use_build_context_synchronously

import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/features/account/model/profile_state.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'profile_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  late FirebaseAuthService _firebaseAuthService;
  late FirestoreService _firestoreService;

  @override
  ProfileState build() {
    _firebaseAuthService = FirebaseAuthService();
    _firestoreService =
        FirestoreService(firebaseAuthService: _firebaseAuthService);
    return bindingData();
  }

  bindingData() {
    final displayEmail = LocalStorageUtils().getKey("email") ?? "";
    final displayName = LocalStorageUtils().getKey("fullname") ?? "";
    final avatarImage = LocalStorageUtils().getKey("avatarImage") ?? "";

    print("User state is ${displayName} ${displayEmail} ${avatarImage}");
    return ProfileState(
        email: displayEmail, fullName: displayName, imageUrl: avatarImage);
  }

  void syncProfileState(String email, String fullName, String? imageUrl) {
    state =
        state.copyWith(fullName: fullName, email: email, imageUrl: imageUrl);
  }

  Future saveUserProfile(String email, String fullName, String? imageUrl,
      WidgetRef contextref) async {
    try {
      if (fullName.isNotEmpty && email.isNotEmpty) {
        await _firestoreService.updateUser(email, fullName, imageUrl);
        syncProfileState(email, fullName, imageUrl);
        await LocalStorageUtils().setKeyString('fullname', fullName);
        await LocalStorageUtils().setKeyString('email', email);
        if (imageUrl != null || imageUrl != "") {
          await LocalStorageUtils().setKeyString('avatarImage', imageUrl!);
        }
        HelpersUtils.showErrorSnackbar(
            duration: 2000,
            contextref.context,
            "Success",
            "Your Profile has been updated",
            StatusSnackbar.success);
      } else {
        HelpersUtils.showErrorSnackbar(
            duration: 2000,
            contextref.context,
            "Validation Failed !!!",
            "Please provide valid email",
            StatusSnackbar.failed);
      }
    } catch (e) {
      HelpersUtils.showErrorSnackbar(
          duration: 3000,
          contextref.context,
          "Oop!!!",
          e.toString(),
          StatusSnackbar.failed);

      rethrow;
    } finally {
      ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }
}
