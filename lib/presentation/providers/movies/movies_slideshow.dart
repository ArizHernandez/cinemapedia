import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayinMoviesProvider);

  return nowPlayingMovies.isEmpty ? [] : nowPlayingMovies.sublist(0, 6);
});
