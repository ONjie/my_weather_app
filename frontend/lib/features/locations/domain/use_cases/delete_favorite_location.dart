import 'package:either_dart/either.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/locations/domain/repositories/locations_repository.dart';

class DeleteFavoriteLocation {
  DeleteFavoriteLocation({
    required this.favoriteLocationsRepository,
  });

  final LocationsRepository favoriteLocationsRepository;

  Future<Either<Failure, bool>> execute({
    required int id,
  }) async =>
      await favoriteLocationsRepository.deleteFavoriteLocation(id: id);
}
