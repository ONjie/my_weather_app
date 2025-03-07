import 'package:either_dart/either.dart';
import 'package:weather_app/features/locations/domain/repositories/locations_repository.dart';

import '../../../../core/failures/failures.dart';
import '../entities/favorite_location_entity.dart';

class AddFavoriteLocation {
  AddFavoriteLocation({required this.favoriteLocationsRepository});

  final LocationsRepository favoriteLocationsRepository;

  Future<Either<Failure, int>> execute(
          {required FavoriteLocationEntity favoriteLocation}) async =>
      await favoriteLocationsRepository.addFavoriteLocation(
          favoriteLocation: favoriteLocation);
}
