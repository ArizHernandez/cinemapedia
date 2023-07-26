import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource _datasource;

  LocalStorageRepositoryImpl(this._datasource);

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return _datasource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadFavoriteMovies({int limit = 10, offset = 0}) {
    return _datasource.loadFavoriteMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    return _datasource.toggleFavorite(movie);
  }
}
