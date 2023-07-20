import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef GetActorsByMovieCallback = Future<List<Actor>> Function(String movieId);

final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>(
  (ref) {
    return ActorsByMovieNotifier(
      getActorsByMovie: ref.watch(actorsRepositoryProvider).getActorsByMovie,
    );
  },
);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsByMovieCallback getActorsByMovie;

  ActorsByMovieNotifier({
    required this.getActorsByMovie,
  }) : super({});

  Future<void> fetchActorsByMovie({String movieId = ""}) async {
    if (state[movieId] != null) return;

    final actors = await getActorsByMovie(movieId);

    state = {...state, movieId: actors};
  }
}
