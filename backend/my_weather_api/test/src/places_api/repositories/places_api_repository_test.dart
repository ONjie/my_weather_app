import 'package:either_dart/either.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/places_api/data_sources/remote_data_source/places_api.dart';
import 'package:my_weather_api/src/places_api/models/place_model.dart';
import 'package:my_weather_api/src/places_api/repositories/places_api_repository.dart';
import 'package:test/test.dart';

import 'places_api_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PlacesApi>()])
void main() {
  late PlacesApiRepositoryImpl placesApiRepositoryImpl;
  late MockPlacesApi mockPlacesApi;

  setUp(() {
    mockPlacesApi = MockPlacesApi();
    placesApiRepositoryImpl = PlacesApiRepositoryImpl(
      placesApi: mockPlacesApi,
    );
  });

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

    test('should return Right(PlaceModel) when response is successful',
        () async {
      //arrange
      when(
        mockPlacesApi.fetchPlaceSuggestions(
          locationName: anyNamed('locationName'),
        ),
      ).thenAnswer((_) async => tPlaceModel);

      //act
      final result = await placesApiRepositoryImpl.fetchPlaceSuggestions(
        locationName: tLocationName,
      );

      //assert
      expect(result, isA<Right<Failure, PlaceModel>>());
      expect(result.right, equals(tPlaceModel));
      verify(
        mockPlacesApi.fetchPlaceSuggestions(
          locationName: anyNamed('locationName'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockPlacesApi);
    });

    test(
        'should return Left(PlacesApiFailure) when PlaceApiException is thrown',
        () async {
      //arrange
      when(
        mockPlacesApi.fetchPlaceSuggestions(
          locationName: anyNamed('locationName'),
        ),
      ).thenThrow(PlacesApiException(message: 'No found'));

      //act
      final result = await placesApiRepositoryImpl.fetchPlaceSuggestions(
        locationName: tLocationName,
      );

      //assert
      expect(result, isA<Left<Failure, PlaceModel>>());
      expect(
        result.left,
        equals(
          const PlacesApiFailure(message: 'No found'),
        ),
      );
      verify(
        mockPlacesApi.fetchPlaceSuggestions(
          locationName: anyNamed('locationName'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockPlacesApi);
    });

     test(
        'should return Left(OtherFailure) when OtherException is thrown',
        () async {
      //arrange
      when(
        mockPlacesApi.fetchPlaceSuggestions(
          locationName: anyNamed('locationName'),
        ),
      ).thenThrow(OtherException(message: 'Unexpected error'));

      //act
      final result = await placesApiRepositoryImpl.fetchPlaceSuggestions(
        locationName: tLocationName,
      );

      //assert
      expect(result, isA<Left<Failure, PlaceModel>>());
      expect(
        result.left,
        equals(
          const OtherFailure(message: 'Unexpected error'),
        ),
      );
      verify(
        mockPlacesApi.fetchPlaceSuggestions(
          locationName: anyNamed('locationName'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockPlacesApi);
    });
  });
}
