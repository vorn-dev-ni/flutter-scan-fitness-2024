import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/data/service/health_connect.dart';
import 'package:demo/features/home/model/user_health.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_health_controller.g.dart';

@riverpod
Future<UserHealth?> userHealthDataPeriodDate(
    Ref ref, DateTime periodDate) async {
  final healthConnects = FlutterHealthConnectService();
  try {
    await Future.delayed(const Duration(milliseconds: 250));
    return await healthConnects.readLatestData(periodDate: periodDate);
  } catch (e) {
    throw AppException(title: "Health Connect Error", message: e.toString());
  }
}

@Riverpod(keepAlive: true)
class UserHealthController extends _$UserHealthController {
  final FirestoreService _firestoreService =
      FirestoreService(firebaseAuthService: FirebaseAuthService());
  final FlutterHealthConnectService healthConnects =
      FlutterHealthConnectService();
  @override
  FutureOr<UserHealth?> build() {
    return _getData();
  }

  Future<UserHealth?> _getData() {
    try {
      DateTime now = DateTime.now();
      DateTime midnight = DateTime(now.year, now.month, now.day, 0, 0, 0);
      return healthConnects.readLatestData(periodDate: midnight);
    } catch (e) {
      throw AppException(title: "Health Connect Error", message: e.toString());
    }
  }
}
