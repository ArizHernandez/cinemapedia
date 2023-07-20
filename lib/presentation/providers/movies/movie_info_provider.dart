import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef GetMovieCallback = Future<Movie> Function({String id});
typedef MovieNotifierState = Map<String, Movie>;

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, MovieNotifierState>((ref) =>
        MovieMapNotifier(
            getMovie: ref.watch(moviesRepositoryProvider).getMovieById));

class MovieMapNotifier extends StateNotifier<MovieNotifierState> {
  final GetMovieCallback getMovie;

  MovieMapNotifier({
    required this.getMovie,
  }) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;

    final movie = await getMovie(id: movieId);

    state = {
      ...state,
      movieId: movie,
    };
  }
}
