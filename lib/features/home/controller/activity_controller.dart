import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'activity_controller.g.dart';

@Riverpod(keepAlive: false)
class ActivityController extends _$ActivityController {
  bool _hasDelayed = false;

  final FirestoreService _firebaseFirestore =
      FirestoreService(firebaseAuthService: FirebaseAuthService());
  @override
  Stream<QuerySnapshot> build(String userId, bool isLimit, int limit,
      {String? sortby}) {
    return _getData(userId, isLimit, limit, sortby: sortby);
  }

  Stream<QuerySnapshot> _getData(String userId, bool isLimit, int limit,
      {String? sortby = 'desc'}) async* {
    ref.read(appLoadingStateProvider.notifier).setState(true);

    if (!_hasDelayed) {
      _hasDelayed = true;
      await Future.delayed(const Duration(seconds: 2));
    }
    ref.read(appLoadingStateProvider.notifier).setState(false);

    yield* _firebaseFirestore.getAllByUserId('activities',
        limit: isLimit ? 4 : 0, sortBy: sortby);
  }
}
