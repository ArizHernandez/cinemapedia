import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef MovieCallback = Future<List<Movie>> Function({int page});
typedef MovieRecommendationCallback = Future<List<Movie>> Function(
    {String movieId, int page});
typedef MovieNotifierState = Map<String, List<Movie>>;

typedef MovieRecommendationsCallback = Future<List<Movie>> Function(
    {int page, String movieId});

final nowPlayinMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    final fetchMoreMovies = ref.watch(moviesRepositoryProvider).getNowPlaying;

    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(moviesRepositoryProvider).getPopular;

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(moviesRepositoryProvider).getUpcoming;

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(moviesRepositoryProvider).getTopRated;

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final movieRecommendationsProvider =
    StateNotifierProvider<MovieRecommendationsNotifier, MovieNotifierState>(
        (ref) {
  final fetchMoreMovies =
      ref.watch(moviesRepositoryProvider).getRecommendations;

  return MovieRecommendationsNotifier(getRecommendations: fetchMoreMovies);
});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currenPage = 0;
  MovieCallback fetchMoreMovies;
  bool isLoading = false;

  MoviesNotifier({
    required this.fetchMoreMovies,
  }) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;

    isLoading = true;
    currenPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currenPage);
    state = [...state, ...movies];
    isLoading = false;
  }
}

class MovieRecommendationsNotifier extends StateNotifier<MovieNotifierState> {
  final MovieRecommendationCallback getRecommendations;

  MovieRecommendationsNotifier({
    required this.getRecommendations,
  }) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;

    final movie = await getRecommendations(movieId: movieId);

    state = {
      ...state,
      movieId: movie,
    };
  }
}
