import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/features/account/controller/profile_controller.dart';
import 'package:demo/features/account/model/payload_profile_state.dart';
import 'package:demo/features/account/model/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_state_controller.g.dart';

@riverpod
class UserStateController extends _$UserStateController {
  @override
  PayloadProfileState build() {
    return PayloadProfileState();
  }

  void updateFullName(String value) {
    state = state.copyWith(fullName: value);
  }

  void updateUserState(ProfileState profile_state) {
    state = state.copyWith(
        email: profile_state.email, fullName: profile_state.fullName);
  }
}
