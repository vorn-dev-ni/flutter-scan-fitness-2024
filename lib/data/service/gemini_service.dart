import 'dart:convert';
import 'dart:async'; // For Stopwatch
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';

class GeminiService {
  final GenerativeModel model = GenerativeModel(
    model: dotenv.env['MODEL']!.toString(),
    apiKey: dotenv.env['GEMINI_API']!.toString(),
  );

  GeminiService();

  Future<Map<String, dynamic>> analyseContent(Iterable<Content> prompt) async {
    final stopwatch = Stopwatch()..start();
    print("Got prompts ${stopwatch.elapsedMilliseconds}");

    try {
      final response = await model.generateContent(prompt);
      final responseString = FormatterUtils.removeJsonString(response!.text!);
      print('Map response: $responseString');
      Map<String, dynamic> mapResponse = json.decode(responseString);

      stopwatch.stop();

      if (mapResponse.isNotEmpty) {
        if (mapResponse.containsKey('code')) {
          print("Caught Error fetching... $mapResponse");
          throw ValidationException(
            title: "Oops",
            message: mapResponse['message'],
          );
        }
      }
      print(
          'Time taken for Gemini response: ${stopwatch.elapsedMilliseconds} ms');
      return mapResponse;
    } catch (e) {
      stopwatch.stop();
      print('Error occurred during Gemini request: $e');
      print('Time taken before error: ${stopwatch.elapsedMilliseconds} ms');
      rethrow;
    }
  }
}
