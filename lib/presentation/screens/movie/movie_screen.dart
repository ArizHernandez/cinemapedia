import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/actors/actors_horizontal_listview.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';

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
 
    ref.read(movieRecommendationsProvider.notifier).loadAll(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final List<Movie> movies = ref.watch(movieRecommendationsProvider);

    if (movies.isEmpty) {
      return const SizedBox(
        height: 380,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return MovieHorizontalListview(
      movies: movies,
      title: "Similar Movies",
      loadNextPage: () => ref
          .read(movieRecommendationsProvider.notifier)
          .loadNextPage(widget.movieId),
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
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(movie.posterPath, width: size.width * 0.3),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(children: [
                  Text(movie.title, style: textStyles.titleLarge),
                  Text(movie.overview, style: textStyles.bodyLarge)
                ]),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
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
        const SizedBox(height: 10),
        _MovieRecommendations(movieId: movie.id.toString()),
        const SizedBox(height: 10),
        _ActorsByMovie(movieId: movie.id.toString()),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _CustomSliverAppbar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppbar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(movie.posterPath, fit: BoxFit.cover),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.7, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0, 0.3],
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                    ],
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
