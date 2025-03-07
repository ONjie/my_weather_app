import 'dart:convert';
import 'package:my_weather_api/src/places_api/models/place_model.dart';
import 'package:test/test.dart';

import '../../../fixtures/fixture_reader.dart';

typedef MapJson = Map<String, dynamic>;

void main() {
  const tProperties = Properties(
    locationName: 'Banjul',
    country: 'The Gambia',
    formatted: 'Banjul, The Gambia',
    lon: -16.575646,
    lat: 13.45535,
  );

  const tFeature = Feature(properties: tProperties);

  const tPlaceModel = PlaceModel(features: [tFeature]);

  group('Properties', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(fixture('geoapify_api_response.json')) as MapJson;

      final json = jsonMap['features'][0]['properties'] as MapJson;

      //act
      final result = Properties.fromJson(json);

      //assert
      expect(result, isA<Properties>());
      expect(result, equals(tProperties));
    });

    test('toJson should return a Json map containing the proper data',
        () async {
      //arrange
      final expectedJson =
          jsonDecode(fixture('geoapify_api_response.json')) as MapJson;

      //act
      final result = tProperties.toJson();

      //assert
      expect(result, isA<MapJson>());
      expect(result, equals(expectedJson['features'][0]['properties']));
    });
  });

  group('Feature', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(fixture('geoapify_api_response.json')) as MapJson;

      final json = jsonMap['features'][0] as MapJson;

      //act
      final result = Feature.fromJson(json);

      //assert
      expect(result, isA<Feature>());
      expect(result, equals(tFeature));
    });

    test('toJson should return a Json map containing the proper data',
        () async {
      //arrange
      final expectedJson =
          jsonDecode(fixture('geoapify_api_response.json')) as MapJson;

      //act
      final result = tFeature.toJson();

      //assert
      expect(result, isA<MapJson>());
      expect(result, equals(expectedJson['features'][0]));
    });
  });

   group('Place Model', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(fixture('geoapify_api_response.json')) as MapJson;

      //act
      final result = PlaceModel.fromJson(jsonMap);

      //assert
      expect(result, isA<PlaceModel>());
      expect(result, equals(tPlaceModel));
    });

    test('toJson should return a Json map containing the proper data', () async {
      //arrange 
      final expectedJson = jsonDecode(fixture('geoapify_api_response.json')) as MapJson;

      //act
      final result = tPlaceModel.toJson();

      //assert
      expect(result, isA<MapJson>());
      expect(result, equals(expectedJson));
    });
  });
}
