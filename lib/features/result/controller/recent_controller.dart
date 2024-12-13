import 'package:demo/features/result/controller/firestore_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'recent_controller.g.dart';

@riverpod
class ResultStateController extends _$ResultStateController {
  @override
  bool build() {
    // TODO: implement ==
    return false;
  }

  void callSyncRecentActivity(searchTitle, imageFile, type) {
    state = true;
    ref
        .read(firestoreControllerProvider.notifier)
        .syncActivity(searchTitle, imageFile, type);
  }
}
