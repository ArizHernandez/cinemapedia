import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home_screen";

  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayinMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(moviesSlideshowProvider);
    final slideShowMovies = ref.watch(nowPlayinMoviesProvider);

    final todayDate =
        HumanFormats.dateToString(date: DateTime.now(), dateFormat: "EEEE d");

    return Column(
      children: [
        const CustomAppbar(),
        MoviesSlideshow(movies: nowPlayingMovies),
        const SizedBox(height: 10),
        MovieHorizontalListview(
          movies: slideShowMovies,
          title: "Now Playing",
          subtitle: todayDate,
          loadNextPage: () =>
              ref.read(nowPlayinMoviesProvider.notifier).loadNextPage(),
        ),
      ],
    );
  }
}
