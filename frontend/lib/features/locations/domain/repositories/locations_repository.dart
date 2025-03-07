import 'package:either_dart/either.dart';

import '../../../../core/failures/failures.dart';
import '../entities/favorite_location_entity.dart';
import '../entities/location_entity.dart';

abstract class LocationsRepository {
  Future<Either<Failure, LocationEntity>>
      fetchLocationsSuggestions({
    required String locationName,
  });
  Future<Either<Failure, int>> addFavoriteLocation({
    required FavoriteLocationEntity favoriteLocation,
  });
  Future<Either<Failure, List<FavoriteLocationEntity>>>
      fetchFavoriteLocations();
  Future<Either<Failure, bool>> deleteFavoriteLocation({
    required int id,
  });
}
