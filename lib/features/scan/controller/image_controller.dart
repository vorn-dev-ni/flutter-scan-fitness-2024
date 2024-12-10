import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'image_controller.g.dart';

@riverpod
class ImageController extends _$ImageController {
  @override
  File? build() => null;

  void updateFile(File file) {
    state = file;
  }
}
