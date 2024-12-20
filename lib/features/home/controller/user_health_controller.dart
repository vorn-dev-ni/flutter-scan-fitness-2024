import 'package:demo/data/service/health_connect.dart';
import 'package:demo/features/home/model/user_health.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_health_controller.g.dart';

@Riverpod(keepAlive: true)
class UserHealthController extends _$UserHealthController {
  final FlutterHealthConnectService healthConnects =
      FlutterHealthConnectService();
  @override
  FutureOr<UserHealth?> build() {
    return _getData();
  }

  Future<UserHealth?> _getData() {
    try {
      return healthConnects.readLatestData();
    } catch (e) {
      throw AppException(title: "Health Connect Error", message: e.toString());
    }
  }
}
