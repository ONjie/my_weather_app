import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/src/places_api/data_sources/remote_data_source/places_api.dart';
import 'package:my_weather_api/src/places_api/models/place_model.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'places_api_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late PlacesApiImpl placesApiImpl;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    placesApiImpl = PlacesApiImpl(dio: mockDio);
  });

  void setUpMockDioSuccess200() {
    when(
      mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        data: jsonDecode(fixture('geoapify_api_response.json'))
            as Map<String, dynamic>,
        statusCode: HttpStatus.ok,
      ),
    );
  }

  void setUpMockDioFailure404() {
    when(
      mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        data: {'message': 'Not Found'},
        statusCode: HttpStatus.notFound,
      ),
    );
  }

  group('fetchPlaceSuggestions', () {
    const tLocationName = 'Banjul';
    const tProperties = Properties(
      locationName: 'Banjul',
      country: 'The Gambia',
      formatted: 'Banjul, The Gambia',
      lon: -16.575646,
      lat: 13.45535,
    );

    const tFeature = Feature(properties: tProperties);

    const tPlaceModel = PlaceModel(features: [tFeature]);

    test(
        'should perform a GET request and return PlaceModel when httpStatus == HttpStatus.ok',
        () async {
      //arrange
      setUpMockDioSuccess200();

      //act
      final result = await placesApiImpl.fetchPlaceSuggestions(
        locationName: tLocationName,
      );

      //assert
      expect(result, isA<PlaceModel>());
      expect(result, equals(tPlaceModel));
      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test(
        'should perform a GET request and throw PlacesApiException when httpStatus == HttpStatus.notFound',
        () async {
      //arrange
      setUpMockDioFailure404();

      //act
      final call = placesApiImpl.fetchPlaceSuggestions;

      //assert
      expect(
        () => call(
          locationName: tLocationName,
        ),
        throwsA(isA<PlacesApiException>()),
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
        'should throw OtherException when an Exception which is not PlacesApiException is thrown',
        () async {
      //arrange
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenThrow(Exception('Unexpected error'));

      //act
      final call = placesApiImpl.fetchPlaceSuggestions;

      //assert
      expect(
        () => call(
          locationName: tLocationName,
        ),
        throwsA(isA<OtherException>()),
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
