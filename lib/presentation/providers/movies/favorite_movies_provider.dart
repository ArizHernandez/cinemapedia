import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isFavoriteMovieProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.read(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

final favoriteMoviesProvider =
    StateNotifierProvider<FavoriteMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return FavoriteMoviesNotifier(localStorageRepository: localStorageRepository);
});

class FavoriteMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  final LocalStorageRepository localStorageRepository;
  int page = 0;

  FavoriteMoviesNotifier({
    required this.localStorageRepository,
  }) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadFavoriteMovies(
      offset: page * 10,
      limit: 20,
    );

    page++;

    final tempMoviesMap = <int, Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }

    state = {...state, ...tempMoviesMap};

    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFavorite(movie);

    final bool isMovieInFavorite = state[movie.id] != null;

    if (isMovieInFavorite) {
      state.remove(movie.id);
      state = {...state};
      return;
    }

    state = {...state, movie.id: movie};
  }
}
