import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_target_controller.g.dart';

@Riverpod(keepAlive: true)
class UserTargetController extends _$UserTargetController {
  bool _hasDelayed = false;

  final FirestoreService _firebaseFirestore =
      FirestoreService(firebaseAuthService: FirebaseAuthService());
  @override
  Stream<DocumentSnapshot> build() {
    return _getData();
  }

  Stream<DocumentSnapshot> _getData() async* {
    ref.read(appLoadingStateProvider.notifier).setState(true);

    if (!_hasDelayed) {
      _hasDelayed = true;
      await Future.delayed(const Duration(seconds: 2));
    }
    ref.read(appLoadingStateProvider.notifier).setState(false);

    yield* _firebaseFirestore.getUserWorkoutGoal(
        _firebaseFirestore.firebaseAuthService!.currentUser!.uid!);
  }

  Future<void> updateTarget(String type, String value, WidgetRef ref) async {
    try {
      await _firebaseFirestore.updateUserTarget(type: type, value: value);
    } catch (e) {
      HelpersUtils.showErrorSnackbar(
          ref.context, 'Oops !!!', e.toString(), StatusSnackbar.failed);
    }
  }
}
