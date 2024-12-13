// ignore: must_be_immutable
import 'package:demo/common/model/youtube_model.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/common/widget/error_fallback.dart';
import 'package:demo/data/repository/youtube_repository_imp.dart';
import 'package:demo/data/service/youtube_service.dart';
import 'package:demo/features/result/controller/youtube_result_controller.dart';
import 'package:demo/utils/constant/api.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/https/https_client.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class ResourceWorkout extends ConsumerStatefulWidget {
  late String title;

  ResourceWorkout({super.key, required this.title});
//  "${ApiUrl.api_youtube}${widget.title}+beginner&type=video&key=${dotenv.get('YOUTUBE_API')}&videoDuration=short"
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResourceWorkoutState();
}

class _ResourceWorkoutState extends ConsumerState<ResourceWorkout> {
  //Improve to Riverpod instead inject manually
  late YoutubeService youtubeService;
  late YoutubeRepository youtubeRepository;
  late HttpsClient httpsClient;
  @override
  void initState() {
    super.initState();
    httpsClient = HttpsClient();
    youtubeService = YoutubeService(
        httpClient: httpsClient,
        url:
            "${ApiUrl.api_youtube}${widget.title}+beginner&type=video&key=${dotenv.get('YOUTUBE_API')}&videoDuration=short");
    youtubeRepository = YoutubeRepository(youtubeService: youtubeService);
  }

  @override
  Widget build(BuildContext context) {
    final youtubeResult =
        ref.watch(YoutubeResultControllerProvider(youtubeRepository));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Sizes.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Resources",
              // textAlign: TextAlign.,
              style: AppTextTheme.lightTextTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            ButtonApp(
                splashColor: AppColors.primaryColor.withOpacity(0.5),
                label: 'Browse',
                onPressed: () {
                  HelpersUtils.deepLinkLauncher(
                      "https://www.youtube.com/results?search_query=${widget.title}+beginner");
                },
                radius: Sizes.lg,
                textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600) as dynamic,
                color: AppColors.secondaryColor,
                textColor: Colors.white,
                elevation: 0),
          ],
        ),
        const SizedBox(height: Sizes.md),
        youtubeResult.when(
          data: (data) {
            if (data is YouTubeSearchResponse) {
              final searchResults = data.items;
              return ListView.builder(
                itemCount: searchResults.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
                    child: ListTile(
                        onTap: () {
                          HelpersUtils.deepLinkLauncher(
                              "${ApiUrl.youtube_schema}${searchResults[index].id.videoId}");
                        },
                        tileColor: AppColors.secondaryColor,
                        splashColor: AppColors.primaryColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Sizes.xl)),
                        contentPadding: const EdgeInsets.all(Sizes.md),
                        title: Text(
                          searchResults[index].snippet.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.lightTextTheme.labelLarge
                              ?.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: Sizes.sm),
                          child: Row(
                            children: [
                              const SizedBox(
                                height: Sizes.md,
                              ),
                              SvgPicture.string(
                                SvgAsset.durationSvg,
                                width: 2.w,
                                height: 2.h,
                                colorFilter: const ColorFilter.mode(
                                    AppColors.primaryColor, BlendMode.srcIn),
                              ),
                              const SizedBox(
                                width: Sizes.xs - 2,
                              ),
                              Text(
                                FormatterUtils.formatAppDateString(
                                    searchResults[index].snippet.publishedAt),
                                style: AppTextTheme.lightTextTheme.labelMedium
                                    ?.copyWith(color: AppColors.primaryColor),
                              ),
                            ],
                          ),
                        ),
                        trailing: SvgPicture.string(
                          SvgAsset.playButtonSvg,
                          width: 30,
                          height: 30,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(Sizes.lg),
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              fadeInCurve: Curves.linear,
                              fadeOutCurve: Curves.bounceOut,
                              width: 15.w,
                              height: 50.h,
                              // imageCacheHeight: 200,
                              // imageCacheWidth: 200,
                              fadeInDuration: const Duration(milliseconds: 500),
                              placeholder: ImageAsset.placeHolderImage,
                              image: searchResults[index]
                                  .snippet
                                  .thumbnails
                                  .medium
                                  .url),
                        )),
                  );
                },
              );
            }
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: errorFallback(
                  AppException(
                      title: "Oops", message: "Something went wrong !!!"),
                  cb: _retry),
            );
          },
          error: (error, stackTrace) {
            // HelpersUtils.showErrorSnackbar(context, title, message, status);
            late AppException _appError =
                AppException(title: 'Oops', message: '');
            if (error is AppException) {
              _appError =
                  AppException(title: error.title, message: error.message);
            }

            if (error is ValidationException) {
              _appError = ValidationException(
                  title: error.title, message: error.message);
            }

            if (error is FormatException) {
              _appError = AppException(title: 'Oops', message: error.message);
            }
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: errorFallback(
                  AppException(
                      title: _appError.title, message: _appError.message),
                  cb: _retry),
            );
          },
          loading: () {
            return appLoadingSpinner();
          },
        )
      ],
    );
  }

  void _retry() {}
}
