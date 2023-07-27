import 'package:cinemapedia/domain/entities/entities.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
  Future<List<Movie>> getRecommendations({String movieId = "", int page = 1});
  Future<Movie> getMovieById({String id = ""});
  Future<List<Movie>> searchMovies(String query);
  Future<List<Video>> getTrailerByMovie({int movieId = 0});
}
