import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';

import 'package:cinemapedia/domain/entities/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);
typedef UpdateSeachCallback = String Function(String Function(String query));

final searchQueryProvider = StateProvider((ref) => "");

final searchMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {
  final searchMovies = ref.watch(moviesRepositoryProvider).searchMovies;

  return SearchMoviesNotifier(
    seachMovies: searchMovies,
    ref: ref,
  );
});

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallback seachMovies;
  final Ref ref;

  SearchMoviesNotifier({
    required this.seachMovies,
    required this.ref,
  }) : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    ref.read(searchQueryProvider.notifier).update((_) => query);

    if (query.isEmpty) {
      state = [];
      return [];
    }

    final movies = await seachMovies(query);

    state = movies;
    return movies;
  }
}
