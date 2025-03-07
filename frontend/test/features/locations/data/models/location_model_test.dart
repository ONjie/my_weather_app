import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/locations/data/models/location_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tProperties = PropertiesModel(
    locationName: 'Banjul',
    country: 'Gambia',
    formatted: 'Banjul, Gambia',
    latitude: 13.4531,
    longitude: -16.5775,
  );

  const tFeature = FeatureModel(properties: tProperties);

  const tLocation = LocationModel(
    features: [tFeature],
  );

  group('LocationModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('places_autocomplete.json'))
              as Map<String, dynamic>;

      //act
      final result = LocationModel.fromJson(jsonMap);

      //assert
      expect(result.features[0], equals(tLocation.features[0]));
      expect(
        result.features[0].properties.locationName,
        equals(
          tLocation.features[0].properties.locationName,
        ),
      );
      expect(
        result.features[0].properties.country,
        equals(
          tLocation.features[0].properties.country,
        ),
      );
      expect(
        result.features[0].properties.formatted,
        equals(
          tLocation.features[0].properties.formatted,
        ),
      );
      expect(
        result.features[0].properties.latitude,
        equals(
          tLocation.features[0].properties.latitude,
        ),
      );
      expect(
        result.features[0].properties.longitude,
        equals(
          tLocation.features[0].properties.longitude,
        ),
      );
    });
  });

  group('FeatureModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('places_autocomplete.json'))
              as Map<String, dynamic>;

      //act
      final result = FeatureModel.fromJson(jsonMap['features'][0]);

      //assert
      expect(result, equals(tFeature));
      expect(
        result.properties.locationName,
        equals(
          tFeature.properties.locationName,
        ),
      );
      expect(
        result.properties.country,
        equals(
          tFeature.properties.country,
        ),
      );
      expect(
        result.properties.formatted,
        equals(
          tFeature.properties.formatted,
        ),
      );
      expect(
        result.properties.latitude,
        equals(
          tFeature.properties.latitude,
        ),
      );
      expect(
        result.properties.longitude,
        equals(
          tFeature.properties.longitude,
        ),
      );
    });
  });

  group('PropertiesModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('places_autocomplete.json'))
              as Map<String, dynamic>;

      //act
      final result = PropertiesModel.fromJson(jsonMap['features'][0]['properties']);

      //assert
      expect(result, equals(tProperties));
      expect(
        result.locationName,
        equals(
          tProperties.locationName,
        ),
      );
      expect(
        result.country,
        equals(
          tProperties.country,
        ),
      );
      expect(
        result.formatted,
        equals(
          tProperties.formatted,
        ),
      );
      expect(
        result.latitude,
        equals(
          tProperties.latitude,
        ),
      );
      expect(
        result.longitude,
        equals(
          tProperties.longitude,
        ),
      );
    });
  });
}
