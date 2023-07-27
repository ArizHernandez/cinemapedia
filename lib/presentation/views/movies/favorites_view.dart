import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> with AutomaticKeepAliveClientMixin{
  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final movies = ref.watch(favoriteMoviesProvider).values.toList();

    if (movies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      final textStyles = Theme.of(context).textTheme;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_sharp, size: 60, color: colors.primary),
            Text(
              "Ohhh no!!",
              style: TextStyle(fontSize: 20, color: colors.primary),
            ),
            Text(
              "You don't have any favorite movie yet.",
              style: textStyles.bodyLarge?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () {
                context.go('/home/0');
              },
              child: const Text("Discover movies"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(movies: movies, loadNextPage: loadNextPage),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
