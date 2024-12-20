import 'dart:io';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/gemini_service.dart';
import 'package:demo/features/result/controller/recent_controller.dart';
import 'package:demo/features/result/model/food_model.dart';
import 'package:demo/features/result/model/gym_model.dart';
import 'package:demo/features/result/model/scan_result_model.dart';
import 'package:demo/features/scan/controller/image_controller.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/string_text.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'scan_result_controller.g.dart';

@Riverpod(keepAlive: true)
class scanResultController extends _$scanResultController {
  late GeminiService _geminiService;
  @override
  FutureOr build(ActivityTag type, GeminiService service, bool isRecent,
      String? imageUrl) async {
    _geminiService = service;
    final imageFile = ref.watch(imageControllerProvider);
    return fetchResult(type, isRecent, imageUrl, imageFile);
  }

  Future<ScanModelResult?> fetchResult(ActivityTag type, bool isRecent,
      String? imageUrl, File? imageFile) async {
    bool _isCancelled = false;
    ref.onDispose(() {
      _isCancelled = true;
    });
    File? resultFile = imageFile;
    print("Start fetching...");
    print(imageUrl);
    try {
      if (dotenv.env.isNotEmpty && imageFile != null || imageUrl != null) {
        if (isRecent == true && imageUrl != null) {
          resultFile = await HelpersUtils.convertUrlToLocalFile(imageUrl);
          // print("Result file is ${resultFile}");
        }

        Map<String, dynamic> resultImage = _getImageDetail(resultFile!);
        final contents = [
          Content.text(type == ActivityTag.food
              ? StringAsset.prompsFoodCalories
              : StringAsset.prompsGym),
          Content.data(resultImage['mimeType'], resultImage['imageBytes']),
        ];
        print("Gemini fetching...");
        Map<String, dynamic> mapResponse =
            await _geminiService.analyseContent(contents);
        if (_isCancelled) {
          throw Exception('Cancelled');
        }
        String searchTitle = type == ActivityTag.food
            ? mapResponse['title']
            : mapResponse['name'];
        if (isRecent == false) {
          ref
              .read(resultStateControllerProvider.notifier)
              .callSyncRecentActivity(searchTitle, imageFile, type);
        }
        dynamic foodModelResult = type == ActivityTag.food
            ? FoodModelResult.fromJson(mapResponse)
            : GymResultModel.fromJson(mapResponse);

        return ScanModelResult(
            modelResult: foodModelResult, imageFile: resultFile);
      }
    } catch (e) {
      kDebugMode ? print("Error during fetching ${e}") : null;

      rethrow;
    }
  }

  Map<String, dynamic> _getImageDetail(File imageFile) {
    final fileExtension = imageFile.path.split('.').last.toLowerCase();
    String mimeType;
    switch (fileExtension) {
      case 'png':
        mimeType = 'image/png';
        break;
      case 'jpg':
        mimeType = 'image/jpg';
      case 'jpeg':
        mimeType = 'image/jpeg';
        break;
      default:
        throw Exception(
            'Unsupported image format. Please upload a PNG, JPEG, or JPG image.');
    }
    final imageBytes = imageFile.readAsBytesSync();
    return {'mimeType': mimeType, 'imageBytes': imageBytes};
  }
}
