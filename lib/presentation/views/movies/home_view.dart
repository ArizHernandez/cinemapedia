import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayinMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);

    final nowPlayingMovies = ref.watch(moviesSlideshowProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final slideShowMovies = ref.watch(nowPlayinMoviesProvider);

    final todayDate =
        HumanFormats.dateToString(date: DateTime.now(), dateFormat: "EEEE d");

    return Visibility(
      visible: !initialLoading,
      replacement: const FullScreenLoader(),
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: CustomAppbar(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Column(
                children: [
                  MoviesSlideshow(movies: nowPlayingMovies),
                  const SizedBox(height: 10),
                  MovieHorizontalListview(
                    movies: slideShowMovies,
                    title: "Now Playing",
                    subtitle: todayDate,
                    loadNextPage: () => ref
                        .read(nowPlayinMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  const SizedBox(height: 10),
                  MovieHorizontalListview(
                    movies: upcomingMovies,
                    title: "Upcoming",
                    subtitle: "This month",
                    loadNextPage: () => ref
                        .read(upcomingMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  const SizedBox(height: 10),
                  MovieHorizontalListview(
                    movies: popularMovies,
                    title: "Popular",
                    loadNextPage: () =>
                        ref.read(popularMoviesProvider.notifier).loadNextPage(),
                  ),
                  const SizedBox(height: 10),
                  MovieHorizontalListview(
                    movies: topRatedMovies,
                    title: "Top rated",
                    loadNextPage: () => ref
                        .read(topRatedMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }, childCount: 1),
          ),
        ],
      ),
    );
  }
}
