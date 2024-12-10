import 'package:demo/features/authentication/model/login_state.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  LoginState build() {
    return LoginState();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  bool? checkValidation(BuildContext context) {
    if (state.email.isEmpty || state.password.isEmpty) {
      ScaffoldMessengerState().clearSnackBars();
      HelpersUtils.showErrorSnackbar(
          context,
          "Validation Error",
          duration: 2000,
          "Missing field please double check",
          StatusSnackbar.failed);
      return false;
    }

    return true;
  }
}
