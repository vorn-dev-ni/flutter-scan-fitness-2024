import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'tabbar_controller.g.dart';

@Riverpod(keepAlive: true)
class TabbarController extends _$TabbarController {
  @override
  int build() {
    return 0;
  }

  void updateIndex(int index) {
    state = index;
  }
}
