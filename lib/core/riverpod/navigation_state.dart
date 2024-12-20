import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'navigation_state.g.dart';

@riverpod
class NavigationState extends _$NavigationState {
  @override
  int build() {
    return 0;
  }

  void changeIndex(int p1) {
    state = p1;
  }
}
