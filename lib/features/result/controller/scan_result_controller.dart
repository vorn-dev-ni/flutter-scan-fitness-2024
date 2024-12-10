import 'dart:convert';
import 'dart:io';
import 'package:demo/data/service/gemini_service.dart';
import 'package:demo/features/result/model/food_model.dart';
import 'package:demo/features/result/model/gym_model.dart';
import 'package:demo/features/result/model/scan_result_model.dart';
import 'package:demo/features/scan/controller/image_controller.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/string_text.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'scan_result_controller.g.dart';

@Riverpod(keepAlive: true)
class scanResultController extends _$scanResultController {
  late GeminiService _geminiService;
  @override
  FutureOr build(ActivityTag type, GeminiService service) async {
    _geminiService = service;
    return fetchResult(ref, type);
  }

  Future<ScanModelResult?> fetchResult(ref, ActivityTag type) async {
    final imageFile = ref.watch(imageControllerProvider);
    try {
      if (dotenv.env.isNotEmpty && imageFile != null) {
        Map<String, dynamic> resultImage = _getImageDetail(imageFile);
        final contents = [
          Content.text(type == ActivityTag.food
              ? StringAsset.prompsFoodCalories
              : StringAsset.prompsGym),
          Content.data(
            resultImage[
                'mimeType'], // MIME type of the image (adjust if needed)
            resultImage['imageBytes'], // Raw image bytes
          ),
        ];

        Map<String, dynamic> mapResponse =
            await _geminiService.analyseContent(contents);

        dynamic foodModelResult = type == ActivityTag.food
            ? FoodModelResult.fromJson(mapResponse)
            : GymResultModel.fromJson(mapResponse);
        print("Food response in result ${foodModelResult}");
        return ScanModelResult(
            modelResult: foodModelResult, imageFile: imageFile);
      }
    } catch (e) {
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
            'Unsupported image format. Please upload a PNG or JPG image.');
    }
    final imageBytes = imageFile.readAsBytesSync();
    return {'mimeType': mimeType, 'imageBytes': imageBytes};
  }
}
