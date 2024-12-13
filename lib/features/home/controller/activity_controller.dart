import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'activity_controller.g.dart';

@Riverpod(keepAlive: true)
class ActivityController extends _$ActivityController {
  final FirestoreService _firebaseFirestore =
      FirestoreService(firebaseAuthService: FirebaseAuthService());
  @override
  Stream<QuerySnapshot> build(String userId, bool isLimit) {
    return _getData(userId, isLimit);
  }

  Stream<QuerySnapshot> _getData(String userId, bool isLimit) {
    return _firebaseFirestore.getAllByUserId('activities',
        limit: isLimit ? 5 : 0);
  }
}
