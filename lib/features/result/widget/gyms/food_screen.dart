import 'dart:io';

import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/error_fallback.dart';
import 'package:demo/data/service/gemini_service.dart';
import 'package:demo/features/result/controller/scan_result_controller.dart';
import 'package:demo/features/result/model/food_model.dart';
import 'package:demo/features/result/model/scan_result_model.dart';
import 'package:demo/features/result/widget/foods/food_detail.dart';
import 'package:demo/features/result/widget/foods/food_score.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:demo/features/result/widget/food_point.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class FoodComponent extends ConsumerStatefulWidget {
  late ActivityTag tag;
  late File file;
  final Function(BuildContext context, ActivityTag tag) onAction;
  FoodComponent(
      {Key? key, required this.tag, required this.file, required this.onAction})
      : super(
          key: key,
        );

  @override
  _FoodComponentState createState() => _FoodComponentState();
}

class _FoodComponentState extends ConsumerState<FoodComponent> {
  late GeminiService _geminiService;
  void _retry() {
    // _showBottomSheet(context, widget.tag);
    widget.onAction(context, widget.tag);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _geminiService = GeminiService(
        model: GenerativeModel(
      model: dotenv.env!['MODEL']?.toString() ?? "",
      apiKey: dotenv!.env!['GEMINI_API'].toString(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    const activityTag = ActivityTag.food;
    final scanResult =
        ref.watch(scanResultControllerProvider(activityTag, _geminiService));
    return scanResult.when(
      data: (data) {
        if (data is ScanModelResult) {
          if (data.modelResult is FoodModelResult) {
            final result = data.modelResult;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                foodPointBuilder(result.nutritionFacts?.take(3).toList()),
                foodPointBuilder(result.nutritionFacts
                    ?.sublist(3, result.nutritionFacts?.length)
                    .toList()),
                foodScore(food: result, file: data.imageFile),
                foodDetail(
                  result,
                ),
              ],
            );
          }
        }
        return errorFallback(
            AppException(title: 'Oops', message: "Something went wrong"),
            cb: _retry);
      },
      error: (error, stackTrace) {
        // HelpersUtils.showErrorSnackbar(context, title, message, status);
        late AppException _appError = AppException(title: 'Oops', message: '');
        if (error is AppException) {
          _appError = AppException(title: error.title, message: error.message);
        }

        if (error is ValidationException) {
          _appError =
              ValidationException(title: error.title, message: error.message);
        }

        if (error is FormatException) {
          _appError = AppException(title: 'Oops', message: error.message);
        }
        return errorFallback(
            AppException(title: _appError.title, message: _appError.message),
            cb: _retry);
      },
      loading: () {
        return appLoadingSpinner();
      },
    );
  }
}

Widget foodPointBuilder(List<NutritionFacts>? foods) {
  return Row(
      children: List.generate(
    foods?.length ?? 0,
    (index) => Expanded(child: foodPoints(foods![index])),
  ));
}