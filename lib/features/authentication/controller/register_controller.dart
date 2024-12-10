import 'package:demo/features/authentication/model/register_state.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'register_controller.g.dart';

@Riverpod(keepAlive: true)
class RegisterController extends _$RegisterController {
  @override
  RegisterState build() {
    return RegisterState();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updateFullname(String value) {
    state = state.copyWith(fullName: value);
  }

  bool? checkValidation(BuildContext context) {
    if (state.email.isEmpty ||
        state.confirmPassword.isEmpty ||
        state.password.isEmpty ||
        state.fullName.isEmpty) {
      ScaffoldMessengerState().clearSnackBars();
      HelpersUtils.showErrorSnackbar(
          context,
          "Validation Error",
          duration: 2000,
          "Missing field please double check",
          StatusSnackbar.failed);
      return false;
    }
    if (state.confirmPassword != state.password) {
      // HelpersUtils.navigatorState(context).pop();
      ScaffoldMessengerState().clearSnackBars();
      HelpersUtils.showErrorSnackbar(
          context,
          "Mismatch Password",
          duration: 2000,
          "Double check your password",
          StatusSnackbar.failed);
      return false;
    }

    return true;
  }
}
