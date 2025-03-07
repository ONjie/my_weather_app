import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/exceptions/exceptions.dart';
import 'package:weather_app/features/locations/data/data_sources/remote_data_source/places_api.dart';
import 'package:weather_app/features/locations/data/models/location_model.dart';

import '../../../../../fixtures/fixture_reader.dart';
import 'places_api_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late PlacesApiImpl placesApiImpl;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    placesApiImpl = PlacesApiImpl(
      dio: mockDio,
    );
  });

  const tProperties = PropertiesModel(
    locationName: 'Banjul',
    country: 'Gambia',
    formatted: 'Banjul, Gambia',
    latitude: 13.4531,
    longitude: -16.5775,
  );

  const tFeature = FeatureModel(properties: tProperties);

  const tLocation = LocationModel(
    features: [tFeature, tFeature],
  );

  const tLocationName = 'Banjul';

  group('fetchLocationsSuggestions', () {
    test(
        'should perform a GET request and return LocationModel when statusCode == HttpStatus.ok',
        () async {
      //arrange
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: jsonDecode(fixture('places_autocomplete_response.json'))
              as Map<String, dynamic>,
          statusCode: HttpStatus.ok,
        ),
      );

      //act
      final result = await placesApiImpl.fetchLocationsSuggestions(
        locationName: tLocationName,
      );

      //assert
      expect(result, isA<LocationModel>());
      expect(result, equals(tLocation));
      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test(
        'should perform a GET request and throw ServerException when statusCode != HttpStatus.ok',
        () async {
      //arrange
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {'error': 'Not Found'},
          statusCode: HttpStatus.notFound,
        ),
      );

      //act
      final call = placesApiImpl.fetchLocationsSuggestions;

      //assert
      expect(
        () => call(locationName: tLocationName),
        throwsA(
          isA<ServerException>(),
        ),
      );
      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test(
        'should throw an OtherException if the Exception is not a ServerException',
        () async {
      //arrange
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenThrow(
        Exception('error'),
      );

      //act
      final call = placesApiImpl.fetchLocationsSuggestions;

      //assert
      expect(
        () => call(locationName: tLocationName),
        throwsA(
          isA<OtherException>(),
        ),
      );
      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });
  });
}
