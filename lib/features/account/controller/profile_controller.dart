// ignore_for_file: use_build_context_synchronously

import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/features/account/model/profile_state.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'profile_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  late FirebaseAuthService _firebaseAuthService;
  late FirestoreService _firestoreService;

  @override
  FutureOr<ProfileState> build() async {
    _firebaseAuthService = FirebaseAuthService();
    _firestoreService =
        FirestoreService(firebaseAuthService: _firebaseAuthService);
    return await bindingData();
  }

  Future<ProfileState> bindingData() async {
    debugPrint('Current user is ${_firebaseAuthService.currentUser}');

    final displayName = _firebaseAuthService.currentUser?.displayName ?? "";
    final data = await _firestoreService.getUserAvatar(
        _firebaseAuthService.currentUser!.uid) as Map<String, dynamic>;
    final displayEmail =
        _firebaseAuthService.currentUser?.email ?? data['email'];

    debugPrint('User email is ${displayEmail}');
    // print(
    //     "User state is ${displayName} ${displayEmail} ${avatarImage} ${gender} ${dob}");
    return ProfileState(
        email: displayEmail,
        fullName: displayName,
        imageUrl: data['avatarImage'] ?? "",
        dob: data['dob'] ?? "",
        gender: data['gender'] ?? "");
  }

  // void syncProfileState(String email, String fullName, String? imageUrl,
  //     {String? gender, String? dob}) {
  //   state = state.copyWith(
  //       fullName: fullName,
  //       email: email,
  //       imageUrl: imageUrl,
  //       dob: dob,
  //       gender: gender);
  // }

  ProfileState getEmailAndDisplayName() {
    final displayEmail = _firebaseAuthService.currentUser?.displayName ?? "";
    return ProfileState(fullName: displayEmail);
  }

  Future saveUserProfile(
      String email, String fullName, String? imageUrl, WidgetRef contextref,
      {String? gender, String? dob}) async {
    try {
      if (fullName.isNotEmpty && email.isNotEmpty) {
        await _firestoreService.updateUser(email, fullName, imageUrl,
            dob: dob, gender: gender);
        contextref.invalidate(profileControllerProvider);
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
            "Please correct your information must not be blank !!!",
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
