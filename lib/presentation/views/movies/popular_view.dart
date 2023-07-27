import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class PopularView extends ConsumerStatefulWidget {
  const PopularView({super.key});

  @override
  PopularViewState createState() => PopularViewState();
}

class PopularViewState extends ConsumerState<PopularView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final movies = ref.watch(popularMoviesProvider);

    return MovieMasonry(
      movies: movies,
      loadNextPage: ref.read(popularMoviesProvider.notifier).loadNextPage,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
