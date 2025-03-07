
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/local_database/database.dart';
import 'package:weather_app/features/locations/data/models/favorite_location_model.dart';
import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';


void main() {
  group('FavoriteLocationModel', () {
    const tFavoriteLocation = FavoriteLocation(
      id: 1,
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    );

    const tFavoriteLocationModel = FavoriteLocationModel(
      id: 1,
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    );


    const tFavoriteLocationEntity = FavoriteLocationEntity(
      id: 1,
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    );

  
    test(
        'toFavoriteLocation should return a valid model when model conversion is successful.',
        () async {
      //arrange & act
      final result = tFavoriteLocationModel.toFavoriteLocation();

      //assert
      expect(result, equals(tFavoriteLocation));
      expect(result.id, equals(tFavoriteLocation.id));
      expect(result.locationName, equals(tFavoriteLocation.locationName));
      expect(result.latitude, equals(tFavoriteLocation.latitude));
      expect(result.longitude, equals(tFavoriteLocation.longitude));
      expect(result.country, equals(tFavoriteLocation.country));
    });

    test(
        'fromFavoriteLocation should return a valid model when model conversion is successful.',
        () async {
      //arrange & act
      final result = FavoriteLocationModel.fromFavoriteLocation(
        favoriteLocation: tFavoriteLocation,
      );

      //assert
      expect(result, equals(tFavoriteLocationModel));
      expect(result.id, equals(tFavoriteLocationModel.id));
      expect(result.locationName, equals(tFavoriteLocationModel.locationName));
      expect(result.latitude, equals(tFavoriteLocationModel.latitude));
      expect(result.longitude, equals(tFavoriteLocationModel.longitude));
      expect(result.country, equals(tFavoriteLocationModel.country));
    });

    test(
        'toFavoriteLocationEntity should return a valid model when model conversion is successful.',
        () async {
      //arrange & act
      final result = tFavoriteLocationModel.toFavoriteLocationEntity();

      //assert
      expect(result, equals(tFavoriteLocationEntity));
      expect(result.id, equals(tFavoriteLocationEntity.id));
      expect(result.locationName, equals(tFavoriteLocationEntity.locationName));
      expect(result.latitude, equals(tFavoriteLocationEntity.latitude));
      expect(result.longitude, equals(tFavoriteLocationEntity.longitude));
      expect(result.country, equals(tFavoriteLocationEntity.country));
    });

    test(
        'fromFavoriteLocationEntity should return a valid model when model conversion is successful.',
        () async {
      //arrange & act
      final result = FavoriteLocationModel.fromLocationEntity(
        favoriteLocation: tFavoriteLocationEntity,
      );

      //assert
      expect(result, equals(tFavoriteLocationModel));
      expect(result.id, equals(tFavoriteLocationModel.id));
      expect(result.locationName, equals(tFavoriteLocationModel.locationName));
      expect(result.latitude, equals(tFavoriteLocationModel.latitude));
      expect(result.longitude, equals(tFavoriteLocationModel.longitude));
      expect(result.country, equals(tFavoriteLocationModel.country));
    });
  });
}
