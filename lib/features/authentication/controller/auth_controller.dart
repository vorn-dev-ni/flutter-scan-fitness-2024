// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/features/account/controller/profile_controller.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/controller/register_controller.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/firebase_auth.dart';
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

  Future<void> _updateUserProfile(
    User user,
    String fullName, {
    String? imageUrl,
  }) async {
    try {
      await user.updateProfile(displayName: fullName);
      await FirestoreService(firebaseAuthService: firebaseAuthService)
          .updateUser(user?.email ?? "", fullName, imageUrl);
      // await user.reload();
    } catch (e) {
      throw FirebaseCredentialException(
          title: "Failed to update user profile",
          message: "There was an error updating the user profile.");
    }
  }

  Future<void> navigateToScreenSuccess(name, email) async {
    try {
      HelpersUtils.navigatorState(ref.context).pushNamedAndRemoveUntil(
          AppPage.EMAIL_VERIFY, ModalRoute.withName(AppPage.EMAIL_VERIFY));
    } catch (e) {
      throw FirebaseCredentialException(
          title: "Failed to send email verification",
          message: "There was an error sending the email verification."
              "There was an error sending the email verification.");
    }
  }

  Future loginWithGoogle() async {
    try {
      ref.read(socaiLoginLoadingStateProvider.notifier).setState(true);
      UserCredential userCredential =
          await firebaseAuthService.signInWithGoogle();

      debugPrint(
          "AUth state is ${userCredential.user?.providerData[0]?.photoURL}");

      String imageUrl = userCredential.user?.providerData[0]?.photoURL ?? "";

      bool isExisted =
          await FirestoreService(firebaseAuthService: firebaseAuthService)
              .isEmailExisted(userCredential.user?.email ?? "");
      await firebaseAuthService.reloadUser();

      if (!isExisted) {
        //Meaning user is first time register with google
        await firebaseAuthService.syncUsertoFirestore(
            userCredential.user?.displayName ?? "",
            userCredential.user?.email ?? "");
        ref.invalidate(profileControllerProvider);
      }
      await syncToStorage(userCredential.user!, imageUrl);

      ref.read(socaiLoginLoadingStateProvider.notifier).setState(false);
    } catch (e) {
      ref.read(socaiLoginLoadingStateProvider.notifier).setState(false);
      rethrow;
    }
  }

  Future syncToStorage(User userCredential, String? imageUrl) async {
    try {
      if (userCredential?.uid != null) {
        final data =
            await FirestoreService(firebaseAuthService: firebaseAuthService)
                .getUserAvatar(userCredential!.uid) as Map<String, dynamic>;
        print("User credential ${data}");
        await _updateUserProfile(userCredential, userCredential.displayName!,
            imageUrl: imageUrl);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser() async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      final userInfo = ref.read(registerControllerProvider);

      final UserCredential? userCredential = await firebaseAuthService
          .createUser(email: userInfo.email, password: userInfo.password);
      if (userCredential?.user != null) {
        await userCredential?.user?.sendEmailVerification();

        await _updateUserProfile(userCredential!.user!, userInfo.fullName);
        await firebaseAuthService.currentUser?.reload();
        if (userCredential.user != null) {
          await firebaseAuthService.syncUsertoFirestore(
              userInfo.fullName ?? "", userInfo.email);
          ref.invalidate(profileControllerProvider);
        }

        ref.read(appLoadingStateProvider.notifier).setState(false);
        await navigateToScreenSuccess(userInfo.fullName, userInfo.email);
        print("User has successfully completed the setup");
      }
    } catch (e) {
      AppException appException = AppException(title: 'Oops', message: '');
      if (e is FirebaseAuthException) {
        String message = FirebaseAuthMessage.getMessage(e.code);
        appException = AppException(title: "Register Failed", message: message);
      }
      if (e is AppException) {
        appException = AppException(title: e.title, message: e.message);
      } else {
        appException =
            AppException(title: "Oops", message: 'Something went wrong');
      }
      ScaffoldMessenger.of(ref.context).removeCurrentSnackBar();
      HelpersUtils.showErrorSnackbar(ref.context, appException.title,
          appException.message, StatusSnackbar.failed);
      ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }

  Future resetPassword(String email) async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      await firebaseAuthService.resetPasswordWithEmail(email);
      HelpersUtils.delay(1000, () {
        HelpersUtils.navigatorState(ref.context)
            .pushNamed(AppPage.SUCCESS_PASSWORD, arguments: {'email': email});
        ref.read(appLoadingStateProvider.notifier).setState(false);
      });
    } catch (e) {
      // print(e);
      ScaffoldMessenger.of(ref.context).removeCurrentSnackBar();
      ref.read(appLoadingStateProvider.notifier).setState(false);
      if (e is FirebaseAuthException) {
        String message = FirebaseAuthMessage.getMessage(e.code);
        HelpersUtils.showErrorSnackbar(
            ref.context,
            "Something went wrong",
            duration: 4000,
            e?.message ?? "",
            StatusSnackbar.failed);
        return;
      }
      HelpersUtils.showErrorSnackbar(
          ref.context,
          "Something went wrong",
          duration: 4000,
          e.toString(),
          StatusSnackbar.failed);

      // ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }

  Future resendPasswordEmail(String email) async {
    try {
      ref.read(appLoadingStateProvider.notifier).setState(true);
      await firebaseAuthService.resetPasswordWithEmail(email);
      ref.read(appLoadingStateProvider.notifier).setState(false);
    } catch (e) {
      HelpersUtils.showErrorSnackbar(ref.context, "Something went wrong",
          e.toString(), StatusSnackbar.failed);
      ref.read(appLoadingStateProvider.notifier).setState(false);

      // ref.read(appLoadingStateProvider.notifier).setState(false);
    }
  }

  Future<void> loginUser(BuildContext context) async {
    try {
      final userInfo = ref.read(loginControllerProvider);
      User? user = await firebaseAuthService.signInWithEmailAndPassword(
          email: userInfo.email, password: userInfo.password);

      if (user?.emailVerified == false) {
        throw AppException(
            title: "Unauthorized", message: 'Please verify your email ');
      }
      if (user != null) {
        await _updateUserProfile(user, user.displayName!);
        await firebaseAuthService.currentUser?.reload();
        await syncToStorage(user!, '');
      }
    } catch (e) {
      ref.read(appLoadingStateProvider.notifier).setState(false);
      ScaffoldMessenger.of(ref.context).removeCurrentSnackBar();
      if (e is FirebaseAuthException) {
        String message = FirebaseAuthMessage.getMessage(e.code);
        HelpersUtils.showErrorSnackbar(
            duration: 4000,
            ref.context,
            "Login Failed !!!",
            message,
            StatusSnackbar.failed);
        rethrow;
      }

      HelpersUtils.showErrorSnackbar(
          duration: 4000,
          ref.context,
          "Firebase Error",
          e.toString(),
          StatusSnackbar.failed);

      rethrow;
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
      await firebaseAuthService.signOutWithGoogle();
      await firebaseAuthService.reloadUser();
    } catch (e) {
      HelpersUtils.showErrorSnackbar(
          ref.context, "Something Wrong", e.toString(), StatusSnackbar.failed);
    }
  }
}
