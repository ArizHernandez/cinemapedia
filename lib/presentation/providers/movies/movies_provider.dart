import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef MovieCallback = Future<List<Movie>> Function({int page});
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
    StateNotifierProvider<MovieRecommendationsNotifier, List<Movie>>((ref) {
  final fetchMoreMovies =
      ref.watch(moviesRepositoryProvider).getRecommendations;

  return MovieRecommendationsNotifier(fetchRecommendations: fetchMoreMovies);
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

class MovieRecommendationsNotifier extends StateNotifier<List<Movie>> {
  int currenPage = 0;
  MovieRecommendationsCallback fetchRecommendations;
  bool isLoading = false;

  MovieRecommendationsNotifier({
    required this.fetchRecommendations,
  }) : super([]);

  Future<void> loadAll(String movieId) async {
    if (isLoading) return;

    isLoading = true;
    currenPage = 1;

    final List<Movie> movies = await fetchRecommendations(
      movieId: movieId,
      page: currenPage,
    );

    state = movies;
    isLoading = false;
  }

  Future<void> loadNextPage(String movieId) async {
    if (isLoading) return;

    isLoading = true;
    currenPage++;

    final List<Movie> movies = await fetchRecommendations(
      movieId: movieId,
      page: currenPage,
    );

    state = [...state, ...movies];
    isLoading = false;
  }
}
