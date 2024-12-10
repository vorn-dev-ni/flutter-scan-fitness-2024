import 'dart:async';
import 'package:demo/common/model/youtube_model.dart';
import 'package:demo/data/repository/youtube_repository_imp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'youtube_result_controller.g.dart';

@Riverpod(keepAlive: true)
class YoutubeResultController extends _$YoutubeResultController {
  late YoutubeRepository _youtubeRepository;

  @override
  FutureOr build(YoutubeRepository youtubeRepository) async {
    _youtubeRepository = youtubeRepository;
    return fetchYoutubeList();
  }

  Future<YouTubeSearchResponse?> fetchYoutubeList() async {
    try {
      YouTubeSearchResponse? youTubeSearchResponse =
          await _youtubeRepository.getAll();
      if (youTubeSearchResponse != null) {
        return youTubeSearchResponse;
      }
    } catch (e) {
      rethrow;
    }
  }
}
