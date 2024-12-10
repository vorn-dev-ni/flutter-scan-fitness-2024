import 'dart:io';

class ScanModelResult {
  final dynamic modelResult; // Can be FoodModelResult or GymResultModel
  final File imageFile; // For the associated image

  ScanModelResult({
    required this.modelResult,
    required this.imageFile,
  });

  @override
  String toString() {
    return 'ScanModelResult(modelResult: $modelResult, imageFile: $imageFile)';
  }
}
