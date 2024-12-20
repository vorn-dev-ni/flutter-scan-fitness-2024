import 'dart:io';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/string_text.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  late WebViewController controller;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // Ensure WebView is initialized for Android.

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              HelpersUtils.delay(0, () {
                setState(() {
                  _isLoading = false;
                });
              });
            }

            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
            setState(() {
              _isLoading = false;
            });
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            // openDialog(request);
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(StringAsset.termsAndConditions));

    if (kIsWeb || !Platform.isMacOS) {
      controller.setBackgroundColor(const Color.fromARGB(128, 255, 255, 255));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        showheader: false,
        bgColor: AppColors.primaryDark,
        foregroundColor: AppColors.backgroundLight,
      ),
      body: SafeArea(
        child: _isLoading
            ? appLoadingSpinner()
            : SingleChildScrollView(
                child: SizedBox(
                    width: 100.w,
                    height: 80.h,
                    child: WebViewWidget(
                      controller: controller,
                    )),
              ),
      ),
    );
  }
}
