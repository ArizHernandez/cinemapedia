import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_details.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieFromMovieDB moviedb) => Movie(
        adult: moviedb.adult,
        backdropPath: moviedb.backdropPath != ""
            ? "https://image.tmdb.org/t/p/w500${moviedb.backdropPath}"
            : "https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound.jpg",
        genreIds: moviedb.genreIds.map((gender) => gender.toString()).toList(),
        id: moviedb.id,
        originalLanguage: moviedb.originalLanguage,
        originalTitle: moviedb.originalTitle,
        overview: moviedb.overview,
        popularity: moviedb.popularity,
        posterPath: moviedb.posterPath != ""
            ? "https://image.tmdb.org/t/p/w500${moviedb.posterPath}"
            : "https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound.jpg",
        releaseDate: moviedb.releaseDate,
        title: moviedb.title,
        video: moviedb.video,
        voteAverage: moviedb.voteAverage,
        voteCount: moviedb.voteCount,
      );

  static Movie movieDetailsToEntity(MovieDBDetails movie) => Movie(
        adult: movie.adult,
        backdropPath: movie.backdropPath != ""
            ? "https://image.tmdb.org/t/p/w500${movie.backdropPath}"
            : "https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound.jpg",
        genreIds: movie.genres.map((gender) => gender.name).toList(),
        id: movie.id,
        originalLanguage: movie.originalLanguage,
        originalTitle: movie.originalTitle,
        overview: movie.overview,
        popularity: movie.popularity,
        posterPath: movie.posterPath != ""
            ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
            : "https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound.jpg",
        releaseDate: movie.releaseDate,
        title: movie.title,
        video: movie.video,
        voteAverage: movie.voteAverage,
        voteCount: movie.voteCount,
      );
}
