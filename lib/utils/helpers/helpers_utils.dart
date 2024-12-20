import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/https/https_client.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:path/path.dart';

class HelpersUtils {
  HelpersUtils._();
  static T? jsonToObject<T>(
      String jsonString, T Function(Map<String, dynamic>) fromJson) {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return fromJson(jsonData);
    } catch (e) {
      print("Error converting JSON to object: $e");
      return null;
    }
  }

  static DateTime getToday() {
    return DateTime.now();
  }

  static showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        'File uploaded successfully!',
        style: AppTextTheme.lightTextTheme.bodySmall,
      )),
    );
  }

  static NavigatorState navigatorState(BuildContext context) {
    return Navigator.of(context);
  }

  static Future<void> removeSplashScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  static Future delay(int miliseconds, Function exce) async {
    await Future.delayed(Duration(milliseconds: miliseconds), () {
      exce();
    });
  }

  static void showErrorSnackbar(
      BuildContext context, String title, String message, StatusSnackbar status,
      {int? duration = 500}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: duration ?? 500),
        content: Column(
          children: [
            Text(
              '${title}',
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                  color: status == StatusSnackbar.success
                      ? AppColors.backgroundLight
                      : AppColors.backgroundLight),
            ),
            Text(
              '${message}',
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: status == StatusSnackbar.success
                      ? AppColors.backgroundLight
                      : AppColors.backgroundLight),
            ),
          ],
        ),
        backgroundColor: status == StatusSnackbar.success
            ? AppColors.primaryColor
            : AppColors.errorColor,
      ),
    );
  }

  static Future showAlertDialog(
    BuildContext context, {
    required String text,
    required String desc,
    required String positiveText,
    required String negativeText,
    required Function onPresspositive,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            text,
            style: AppTextTheme.lightTextTheme.headlineSmall,
          ),
          content: Text(
            desc,
            style: AppTextTheme.lightTextTheme.labelLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                onPresspositive();
                // HelpersUtils.deepLinkLauncher(url);
                // HelpersUtils.navigatorState(context).pop();
              },
              child: Text(positiveText),
            ),
            TextButton(
              onPressed: () {
                HelpersUtils.navigatorState(context).pop();
              },
              child: Text(negativeText),
            ),
          ],
        );
      },
    );
  }

  static Future<File?> convertUrlToLocalFile(String url) async {
    try {
      final response = await HttpsClient().httpClients.get(
            url,
            options: Options(
              responseType: ResponseType.bytes,
            ),
          );

      final Response? result = validateResponse(response);
      print("convertUrlToLocalFile fetching...");

      final Uint8List bytes = result?.data;

      final dir = await getTemporaryDirectory();
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${dir.path}/$uniqueFileName';
      final file = File(filePath);
      return await file.writeAsBytes(bytes);
    } catch (e) {
      print('Error downloading image: $e');

      throw AppException(
          title: "Something went wrong",
          message: "Failed to get image resource");

      // rethrow;
    }
    return null;
  }

  static String timeAgo(String inputDate) {
    if (inputDate.isEmpty) {
      return "";
    }

    final DateFormat inputFormat =
        DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC+7'");
    final DateTime dateTime;
    try {
      dateTime = inputFormat.parse(inputDate);
    } catch (e) {
      return "";
    }

    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "$months months ago";
    } else {
      final years = (difference.inDays / 365).floor();
      return "$years years ago";
    }
  }

  static Response validateResponse(Response response) {
    final statusCode = response.statusCode;

    print("statusCode ${statusCode}");

    if (statusCode != null) {
      if (statusCode >= 200 && statusCode < 300) {
        return response; // Return the response if status is in the 2xx range
      } else {
        // Handle specific status codes
        switch (statusCode) {
          case 400:
            throw BadRequestException(
                message: "${response.statusMessage}", title: "Bad Request");
          case 401:
            throw ForbiddenException(
                message: '${response.statusMessage}', title: 'Unauthorize');
          case 403:
            throw ForbiddenException(
                message: '${response.statusMessage}', title: 'Unauthorize');
          case 404:
            throw NotFoundException(
                message: '${response.statusMessage}', title: 'Not Found');
          case 500:
            throw InternalServerException(
                message: '${response.statusMessage}', title: 'Server is Down');
          default:
            throw UnknownException(
                message: '${response.statusMessage}', title: 'Oops');
        }
      }
    } else {
      throw UnknownException(
          title: "Oops", message: "Response does not contain a status code");
    }
  }

  static Future<void> deepLinkLauncher(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
