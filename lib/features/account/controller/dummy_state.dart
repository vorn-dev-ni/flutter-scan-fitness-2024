import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'dummy_state.g.dart';

@Riverpod(keepAlive: true)
class DummyStateController extends _$DummyStateController {
  @override
  String build() {
    // TODO: implement ==
    return "Hello world";
  }

  void update() {
    state = "New Value";
  }
}
