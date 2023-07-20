import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/casts_response.dart';

class ActorsMovieDBDatasource extends ActorsDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: "https://api.themoviedb.org/3",
    queryParameters: {
      "api_key": Environment.movieDBKey,
      "language": "es-MX",
    },
  ));

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get("/movie/$movieId/credits");

    if (response.statusCode != 200) {
      throw Exception(
          "An Error occurred while fetching actors: ${response.data}");
    }

    final CastsResponse castsResponse = CastsResponse.fromJson(response.data);
    final List<Actor> actors = castsResponse.cast
        .map((cast) => ActorMapper.castsToEntity(cast))
        .toList();

    return actors;
  }
}
