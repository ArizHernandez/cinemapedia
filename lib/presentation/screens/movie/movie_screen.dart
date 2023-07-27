import 'package:cinemapedia/presentation/widgets/videos/movie_video_player.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/actors/actors_horizontal_listview.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const String name = "movie_screen";

  final String movieId;

  const MovieScreen({
    super.key,
    required this.movieId,
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          strokeWidth: 2,
        )),
      );
    }

    return FadeIn(
      child: Scaffold(
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            _CustomSliverAppbar(movie: movie),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _MovieDetails(
                  movie: movie,
                ),
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomSliverAppbar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppbar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isFavoriteMovie = ref.watch(isFavoriteMovieProvider(movie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            await ref
                .read(favoriteMoviesProvider.notifier)
                .toggleFavorite(movie);

            ref.invalidate(isFavoriteMovieProvider(movie.id));
          },
          icon: isFavoriteMovie.when(
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
            data: (isFavorite) => isFavorite
                ? const Icon(Icons.favorite_rounded, color: Colors.red)
                : const Icon(Icons.favorite_border_rounded),
            error: (_, __) => throw UnimplementedError(),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        title: const _CustomGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.7, 1],
          colors: [
            Colors.transparent,
            Colors.black45,
          ],
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return FadeIn(child: child);

                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
            ),
            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.3],
              colors: [
                Colors.black26,
                Colors.transparent,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final Alignment begin;
  final Alignment end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.begin,
    required this.end,
    required this.stops,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MovieOverview(movie: movie, size: size, textStyles: textStyles),
        _MovieGenreChipList(movie: movie),
        const SizedBox(height: 10),
        _MovieRecommendations(movieId: movie.id.toString()),
        const SizedBox(height: 10),
        MovieVideoPlayer(movieId: movie.id),
        const SizedBox(height: 10),
        _ActorsByMovie(movieId: movie.id.toString()),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie({
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actors = ref.watch(actorsByMovieProvider);

    ref
        .read(actorsByMovieProvider.notifier)
        .fetchActorsByMovie(movieId: movieId);

    if (actors[movieId] == null) {
      return const CircularProgressIndicator(
        strokeWidth: 2,
      );
    }

    return ActorsHorizontalListview(
      actors: actors[movieId]!,
    );
  }
}

class _MovieRecommendations extends ConsumerStatefulWidget {
  final String movieId;

  const _MovieRecommendations({
    required this.movieId,
  });

  @override
  _MovieRecommendationsState createState() => _MovieRecommendationsState();
}

class _MovieRecommendationsState extends ConsumerState<_MovieRecommendations> {
  @override
  void initState() {
    super.initState();

    ref.read(movieRecommendationsProvider.notifier).loadMovie(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final List<Movie>? movies =
        ref.watch(movieRecommendationsProvider)[widget.movieId];

    if (movies == null) {
      return const SizedBox(
        height: 380,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (movies.isEmpty) {
      return SizedBox(
        height: 50,
        child: Center(
          child: Text(
            "No similar movies found.",
            style: textStyles.bodyLarge,
          ),
        ),
      );
    }

    return MovieHorizontalListview(
        movies: movies,
        title: "Similar Movies",
        loadNextPage: () => ref.read(movieRecommendationsProvider.notifier));
  }
}

class _MovieOverview extends StatelessWidget {
  const _MovieOverview({
    required this.movie,
    required this.size,
    required this.textStyles,
  });

  final Movie movie;
  final Size size;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(movie.posterPath, width: size.width * 0.3),
              ),
              SizedBox(
                height: 30,
                width: size.width * 0.3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_half_rounded,
                      color: Colors.yellow.shade700,
                    ),
                    Text(
                      HumanFormats.numberCompact(movie.voteAverage, 1),
                      style: textStyles.bodyLarge?.copyWith(
                        color: Colors.yellow.shade800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      HumanFormats.numberCompact(movie.popularity),
                      style: textStyles.bodyLarge,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: (size.width - 40) * 0.7,
            child: Column(children: [
              Text(movie.title, style: textStyles.titleLarge),
              Text(
                movie.overview,
                style: textStyles.bodyLarge
                    ?.copyWith(overflow: TextOverflow.ellipsis),
                maxLines: 10,
              )
            ]),
          )
        ],
      ),
    );
  }
}

class _MovieGenreChipList extends StatelessWidget {
  final Movie movie;

  const _MovieGenreChipList({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...movie.genreIds.map(
              (genre) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Chip(
                  label: Text(genre),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
