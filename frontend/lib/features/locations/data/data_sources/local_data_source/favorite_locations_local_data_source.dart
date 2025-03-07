import 'package:weather_app/core/local_database/database.dart';
import 'package:weather_app/features/locations/data/models/favorite_location_model.dart';

abstract class FavoriteLocationsLocalDataSource {
  Future<int> addFavoriteLocation({
    required FavoriteLocationModel favoriteLocation,
  });
  Future<List<FavoriteLocationModel>> fetchFavoriteLocations();
  Future<bool> deleteFavoriteLocation({required int id});
}

class FavoriteLocationsLocalDataSourceImpl
    implements FavoriteLocationsLocalDataSource {
  final AppDatabase appDatabase;

  FavoriteLocationsLocalDataSourceImpl({required this.appDatabase});

  @override
  Future<int> addFavoriteLocation({
    required FavoriteLocationModel favoriteLocation,
  }) async {
    final generatedId =
        await appDatabase.into(appDatabase.favoriteLocations).insert(
              FavoriteLocationsCompanion.insert(
                locationName: favoriteLocation.locationName,
                country: favoriteLocation.country,
                latitude: favoriteLocation.latitude,
                longitude: favoriteLocation.longitude,
              ),
            );
    return generatedId;
  }

  @override
  Future<List<FavoriteLocationModel>> fetchFavoriteLocations() async {
    final favoriteLocations =
        await appDatabase.select(appDatabase.favoriteLocations).get();
    return favoriteLocations
        .map(
          (favoriteLocation) => FavoriteLocationModel.fromFavoriteLocation(
            favoriteLocation: favoriteLocation,
          ),
        )
        .toList();
  }

  @override
  Future<bool> deleteFavoriteLocation({
    required int id,
  }) async {
    return await (appDatabase.delete(appDatabase.favoriteLocations)
              ..where(
                (t) => t.id.equals(id),
              ))
            .go() ==
        1;
  }
}
