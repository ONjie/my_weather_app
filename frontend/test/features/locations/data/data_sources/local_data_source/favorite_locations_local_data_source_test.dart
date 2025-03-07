import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/local_database/database.dart';
import 'package:weather_app/features/locations/data/data_sources/local_data_source/favorite_locations_local_data_source.dart';
import 'package:weather_app/features/locations/data/models/favorite_location_model.dart';

void main() {
  late FavoriteLocationsLocalDataSourceImpl locationsLocalDataSource;
  late AppDatabase appDatabase;

  setUp(() {
    appDatabase = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );

    locationsLocalDataSource = FavoriteLocationsLocalDataSourceImpl(
      appDatabase: appDatabase,
    );
  });
  tearDown(() {
    appDatabase.close();
  });

  group('addFavoriteLocation', () {
    const tFavoriteLocation = FavoriteLocationModel(
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    );

    test('should return int when the favoriteLocation is added successfully',
        () async {
      //arrange
      const tGeneratedId = 1;

      //act
      final result = await locationsLocalDataSource.addFavoriteLocation(
        favoriteLocation: tFavoriteLocation,
      );

      expect(result, isA<int>());
      expect(result, equals(tGeneratedId));
    });
  });

  group('fetchFavoriteLocations', () {
    const tFavoriteLocation = FavoriteLocationModel(
      id: 1,
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    );

    test('should return List<FavoriteLocationModel> when successful', () async {
      //arrange
      appDatabase.into(appDatabase.favoriteLocations).insert(
            FavoriteLocationsCompanion.insert(
              locationName: tFavoriteLocation.locationName,
              country: tFavoriteLocation.country,
              latitude: tFavoriteLocation.latitude,
              longitude: tFavoriteLocation.longitude,
            ),
          );

      //act
      final result = await locationsLocalDataSource.fetchFavoriteLocations();

      //assert
      expect(result, isA<List<FavoriteLocationModel>>());
      expect(result, equals([tFavoriteLocation]));
    });
  });

  group('deleteFavoriteLocation', () {
    const tId = 1;

    test('should return true when the favoriteLocation is deleted successfully',
        () async {
      //arrange
      appDatabase.into(appDatabase.favoriteLocations).insert(
            FavoriteLocationsCompanion.insert(
              locationName: 'Banjul',
              country: 'Gambia',
              latitude: 13.4531,
              longitude: -16.5775,
            ),
          );

      //act
      final result = await locationsLocalDataSource.deleteFavoriteLocation(
        id: tId,
      );

      //assert
      expect(result, isA<bool>());
      expect(result, equals(true));
    });
  });
}
