import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_video.dart';

class VideoMapper {
  static Video moviedbVideoToEntity(VideoResult video) => Video(
        id: video.id,
        name: video.name,
        youtubeKey: video.key,
        publishedAt: video.publishedAt,
      );
}
