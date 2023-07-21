import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/theme/theme_provider.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isDarkTheme = ref.watch(isDarkThemeProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(
                Icons.movie_creation_outlined,
                color: colors.primary,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Cinemapedia',
                style: textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    ref.read(isDarkThemeProvider.notifier).state = !isDarkTheme;
                  },
                  icon: Icon(isDarkTheme ? Icons.dark_mode : Icons.light_mode)),
              IconButton(
                onPressed: () {
                  final searchMovie = ref.watch(searchMoviesProvider);
                  final searchQuery = ref.watch(searchQueryProvider);

                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      searchMovies: ref
                          .read(searchMoviesProvider.notifier)
                          .searchMoviesByQuery,
                      initialMovies: searchMovie,
                    ),
                  ).then((movie) => (movie != null)
                      ? context.push('/movie/${movie.id}')
                      : null);
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
