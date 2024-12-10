// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/controller/register_controller.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController {
  late WidgetRef ref;
  late FirebaseAuthService firebaseAuthService;

  AuthController({
    required this.firebaseAuthService,
    required this.ref,
  });

  Future<void> _updateUserProfile(User user, String fullName) async {
    try {
      await user.updateProfile(displayName: fullName);
      // await user.reload();
    } catch (e) {
      throw FirebaseCredentialException(
          title: "Failed to update user profile",
          message: "There was an error updating the user profile.");
    }
  }

  Future<void> navigateToScreenSuccess(name, email) async {
    try {
      // await _updateUserProfile(user, user!.displayName!);

      LocalStorageUtils().setKeyString("fullname", name ?? "");
      LocalStorageUtils().setKeyString("email", email ?? "");

      HelpersUtils.delay(100, () {
        HelpersUtils.navigatorState(ref.context).pushNamedAndRemoveUntil(
            AppPage.EMAIL_VERIFY, ModalRoute.withName(AppPage.EMAIL_VERIFY));
      });
    } catch (e) {
      throw FirebaseCredentialException(
          title: "Failed to send email verification",
          message: "There was an error sending the email verification."
              "There was an error sending the email verification.");
    }
  }

  Future<void> createUser() async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);

      final userInfo = ref.read(registerControllerProvider);
      final UserCredential? userCredential = await firebaseAuthService
          .createUser(email: userInfo.email, password: userInfo.password);
      if (userCredential?.user != null) {
        await _updateUserProfile(userCredential!.user!, userInfo.fullName);
        await userCredential?.user?.sendEmailVerification();
        await navigateToScreenSuccess(userInfo.fullName, userInfo.email);
        ref.read(appLoadingStateProvider.notifier).setState(false);
        print("User has successfully completed the setup");
      }
    } catch (e) {
      if (e is AppException) {
        HelpersUtils.showErrorSnackbar(
            ref.context, e.title, e.message, StatusSnackbar.failed);
      } else {
        HelpersUtils.showErrorSnackbar(ref.context, "Server Error",
            "Something  went wrong", StatusSnackbar.failed);
      }
      ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }

  Future<void> loginUser() async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      // final userInfo = ref.read(registerControllerProvider);
      // print("User info is ${userInfo.email}");
      final userInfo = ref.read(loginControllerProvider);
      User? user = await firebaseAuthService.signInWithEmailAndPassword(
          email: userInfo.email, password: userInfo.password);

      if (user?.emailVerified == false) {
        throw AppException(
            title: "Unauthorized", message: 'Please verify your email ');
      }
      if (user != null) {
        LocalStorageUtils().setKeyString("fullname", user.displayName ?? "");
        LocalStorageUtils().setKeyString("email", user.email ?? "");
      }
      ref.read(appLoadingStateProvider.notifier).setState(false);
      await firebaseAuthService.currentUser?.reload();
    } catch (e) {
      HelpersUtils.showErrorSnackbar(
          ref.context, "Firebase Error", e.toString(), StatusSnackbar.failed);
      ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }

  Future<void> logoutUser() async {
    try {
      // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      // await firebaseAuth.signOut();
      await LocalStorageUtils().clear();
      if (kDebugMode) {
        print("LocalStorageUtils has clear all");
      }

      await firebaseAuthService.signOut();
    } catch (e) {
      HelpersUtils.showErrorSnackbar(
          ref.context, "Something Wrong", e.toString(), StatusSnackbar.failed);
    }
  }
}
