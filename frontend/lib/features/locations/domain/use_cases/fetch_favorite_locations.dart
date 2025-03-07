import 'package:either_dart/either.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';
import 'package:weather_app/features/locations/domain/repositories/locations_repository.dart';

class FetchFavoriteLocations {
  FetchFavoriteLocations({required this.favoriteLocationsRepository});

  final LocationsRepository favoriteLocationsRepository;

  Future<Either<Failure, List<FavoriteLocationEntity>>> execute() async =>
      await favoriteLocationsRepository.fetchFavoriteLocations();
}
