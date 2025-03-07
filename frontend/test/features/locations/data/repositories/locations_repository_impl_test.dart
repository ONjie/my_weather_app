import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/exceptions/exceptions.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/core/utils/response.dart';
import 'package:weather_app/features/locations/data/data_sources/local_data_source/favorite_locations_local_data_source.dart';
import 'package:weather_app/features/locations/data/data_sources/remote_data_source/places_api.dart';
import 'package:weather_app/features/locations/data/models/favorite_location_model.dart';
import 'package:weather_app/features/locations/data/models/location_model.dart';
import 'package:weather_app/features/locations/data/repositories/locations_repository_impl.dart';
import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';
import 'package:weather_app/features/locations/domain/entities/location_entity.dart';

import 'locations_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FavoriteLocationsLocalDataSource>()])
@GenerateNiceMocks([MockSpec<PlacesApi>()])
@GenerateNiceMocks([MockSpec<NetworkInfo>()])
void main() {
  late LocationsRepositoryImpl locationsRepositoryImpl;
  late MockFavoriteLocationsLocalDataSource
      mockFavoriteLocationsLocalDataSource;
  late MockPlacesApi mockPlacesApi;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockFavoriteLocationsLocalDataSource =
        MockFavoriteLocationsLocalDataSource();
    mockPlacesApi = MockPlacesApi();
    mockNetworkInfo = MockNetworkInfo();
    locationsRepositoryImpl = LocationsRepositoryImpl(
      favoriteLocationsLocalDataSource: mockFavoriteLocationsLocalDataSource,
      networkInfo: mockNetworkInfo,
      locationsApi: mockPlacesApi,
    );
  });

  void runOnlineTest(Function body) {
    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runOfflineTest(Function body) {
    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('addFavoriteLocation', () {
    const favoriteLocationEntity = FavoriteLocationEntity(
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    );
    test(
        'should return Left(DatabaseFailure) when adding favorite location is unsuccessful and generatedId is less than or equal to 0',
        () async {
      // arrange
      when(mockFavoriteLocationsLocalDataSource.addFavoriteLocation(
        favoriteLocation: anyNamed('favoriteLocation'),
      )).thenAnswer(
        (_) async => 0,
      );

      // act
      final result = await locationsRepositoryImpl.addFavoriteLocation(
        favoriteLocation: favoriteLocationEntity,
      );

      // assert
      expect(
        result,
        const Left(
          DatabaseFailure(
            message: 'Failed to add favorite location',
          ),
        ),
      );
      verify(mockFavoriteLocationsLocalDataSource.addFavoriteLocation(
        favoriteLocation: anyNamed('favoriteLocation'),
      )).called(1);
      verifyNoMoreInteractions(
        mockFavoriteLocationsLocalDataSource,
      );
    });

    test(
        'should return Right(generatedId) when favorite location is added successfully and generatedId is greater than 0',
        () async {
      // arrange
      when(mockFavoriteLocationsLocalDataSource.addFavoriteLocation(
        favoriteLocation: anyNamed('favoriteLocation'),
      )).thenAnswer(
        (_) async => 1,
      );

      // act
      final result = await locationsRepositoryImpl.addFavoriteLocation(
        favoriteLocation: favoriteLocationEntity,
      );

      // assert
      expect(result, equals(const Right(1)));
      verify(mockFavoriteLocationsLocalDataSource.addFavoriteLocation(
        favoriteLocation: anyNamed('favoriteLocation'),
      )).called(1);
      verifyNoMoreInteractions(
        mockFavoriteLocationsLocalDataSource,
      );
    });

    test('should return Left(OtherFailure) when an exception is thrown',
        () async {
      // arrange
      when(mockFavoriteLocationsLocalDataSource.addFavoriteLocation(
        favoriteLocation: anyNamed('favoriteLocation'),
      )).thenThrow(
        Exception(
          'Unexpected error',
        ),
      );

      // act
      final result = await locationsRepositoryImpl.addFavoriteLocation(
        favoriteLocation: favoriteLocationEntity,
      );

      // assert
      expect(
        result,
        const Left(
          OtherFailure(
            message: 'Exception: Unexpected error',
          ),
        ),
      );
      verify(mockFavoriteLocationsLocalDataSource.addFavoriteLocation(
        favoriteLocation: anyNamed('favoriteLocation'),
      )).called(1);
    });
  });

  group('deleteFavoriteLocation', () {
    const tId = 1;
    test(
        'should return Left(DatabaseFailure) when deleting favorite location is unsuccessful',
        () async {
      // arrange
      when(mockFavoriteLocationsLocalDataSource.deleteFavoriteLocation(
        id: anyNamed('id'),
      )).thenAnswer(
        (_) async => false,
      );

      // act
      final result = await locationsRepositoryImpl.deleteFavoriteLocation(
        id: tId,
      );

      // assert
      expect(
        result,
        const Left(
          DatabaseFailure(
            message: 'Failed to delete favorite location',
          ),
        ),
      );
      verify(mockFavoriteLocationsLocalDataSource.deleteFavoriteLocation(
        id: anyNamed('id'),
      )).called(1);
      verifyNoMoreInteractions(
        mockFavoriteLocationsLocalDataSource,
      );
    });

    test(
        'should return Right(true) when favorite location is deleted successfully',
        () async {
      // arrange
      when(mockFavoriteLocationsLocalDataSource.deleteFavoriteLocation(
        id: anyNamed('id'),
      )).thenAnswer(
        (_) async => true,
      );

      // act
      final result = await locationsRepositoryImpl.deleteFavoriteLocation(
        id: tId,
      );

      // assert
      expect(result, equals(const Right(true)));
      verify(mockFavoriteLocationsLocalDataSource.deleteFavoriteLocation(
        id: anyNamed('id'),
      )).called(1);
      verifyNoMoreInteractions(
        mockFavoriteLocationsLocalDataSource,
      );
    });

    test('should return Left(OtherFailure) when an exception is thrown',
        () async {
      // arrange
      when(mockFavoriteLocationsLocalDataSource.deleteFavoriteLocation(
        id: anyNamed('id'),
      )).thenThrow(
        Exception(
          'Unexpected error',
        ),
      );

      // act
      final result = await locationsRepositoryImpl.deleteFavoriteLocation(
        id: tId,
      );

      // assert
      expect(
        result,
        const Left(
          OtherFailure(
            message: 'Exception: Unexpected error',
          ),
        ),
      );
      verify(mockFavoriteLocationsLocalDataSource.deleteFavoriteLocation(
        id: anyNamed('id'),
      )).called(1);
    });
  });

  group('fetchFavoriteLocations', () {
    const favoriteLocationEntity = FavoriteLocationEntity(
      id: 1,
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    );
    const favoriteLocationModel = FavoriteLocationModel(
      id: 1,
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    );

    test('should return Left(DatabaseFailure) when no favorite location exists',
        () async {
      //arrange
      when(
        mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
      ).thenAnswer(
        (_) async => [],
      );

      // act
      final result = await locationsRepositoryImpl.fetchFavoriteLocations();

      // assert
      expect(
        result.fold(
          (left) => left,
          (right) => null,
        ),
        equals(
          const DatabaseFailure(
            message: 'No favorite locations found',
          ),
        ),
      );
      verify(
        mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
      ).called(1);
      verifyNoMoreInteractions(
        mockFavoriteLocationsLocalDataSource,
      );
    });

    test(
        'should return Right(List<FavoriteLocationEntity>) when favorite locations are fetched successfully',
        () async {
      // arrange
      when(
        mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
      ).thenAnswer(
        (_) async => [favoriteLocationModel],
      );

      // act
      final result = await locationsRepositoryImpl.fetchFavoriteLocations();

      // assert
      expect(
        result.fold(
          (left) => null,
          (right) => right,
        ),
        equals(
          [favoriteLocationEntity],
        ),
      );
      verify(
        mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
      ).called(1);
      verifyNoMoreInteractions(
        mockFavoriteLocationsLocalDataSource,
      );
    });

    test('should return Left(OtherFailure) when an exception is thrown',
        () async {
      // arrange
      when(
        mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
      ).thenThrow(
        Exception(
          'Unexpected error',
        ),
      );

      // act
      final result = await locationsRepositoryImpl.fetchFavoriteLocations();

      // assert
      expect(
        result.fold(
          (left) => left,
          (right) => null,
        ),
        equals(
          const OtherFailure(
            message: 'Exception: Unexpected error',
          ),
        ),
      );
      verify(
        mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
      ).called(1);
    });
  });

  group('fetchLocationsSuggestions', () {
    const tLocationName = 'Banjul';

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
    test('checks if the device online', () async {
      when(
        mockNetworkInfo.isConnected,
      ).thenAnswer(
        (_) async => false,
      );

      locationsRepositoryImpl.fetchLocationsSuggestions(
          locationName: tLocationName);

      verify(mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTest(() {
      test(
          'should return Left(InternetConnectionFailure) when there is no internet connection',
          () async {
        // act
        final result = await locationsRepositoryImpl.fetchLocationsSuggestions(
          locationName: tLocationName,
        );

        // assert
        expect(
          result,
          isA<Left<Failure, LocationEntity>>(),
        );
        expect(
          result.fold(
            (left) => left,
            (right) => null,
          ),
          equals(
            const InternetConnectionFailure(
              message: noInternetConnection,
            ),
          ),
        );
        verify(mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
      });
    });

    runOnlineTest(() {
      test(
          'should return Right(LocationEntity) when locations suggestions are fetched successfully',
          () async {
        // arrange
        when(
          mockPlacesApi.fetchLocationsSuggestions(
            locationName: anyNamed('locationName'),
          ),
        ).thenAnswer(
          (_) async => tLocation,
        );

        // act
        final result = await locationsRepositoryImpl.fetchLocationsSuggestions(
          locationName: tLocationName,
        );

        // assert
        expect(
          result,
          isA<Right<Failure, LocationEntity>>(),
        );
        expect(
          result.fold(
            (left) => null,
            (right) => right,
          ),
          equals(
            tLocation.toLocationEntity(),
          ),
        );
        verify(
          mockPlacesApi.fetchLocationsSuggestions(
            locationName: anyNamed('locationName'),
          ),
        ).called(1);
        verifyNoMoreInteractions(
          mockPlacesApi,
        );
      });

      test('should return Left(ServerFailure) when ServerException is thrown',
          () async {
        //arrange
        when(
          mockPlacesApi.fetchLocationsSuggestions(
            locationName: anyNamed('locationName'),
          ),
        ).thenThrow(
          ServerException(
            message: 'Failed to fetch locations',
          ),
        );

        // act
        final result = await locationsRepositoryImpl.fetchLocationsSuggestions(
          locationName: tLocationName,
        );

        // assert
        expect(
          result,
          isA<Left<Failure, LocationEntity>>(),
        );
        expect(
          result.fold(
            (left) => left,
            (right) => null,
          ),
          equals(
            const ServerFailure(
              message: 'Failed to fetch locations',
            ),
          ),
        );
        verify(
          mockPlacesApi.fetchLocationsSuggestions(
            locationName: anyNamed('locationName'),
          ),
        ).called(1);
        verifyNoMoreInteractions(
          mockPlacesApi,
        );
      });

      test('should return Left(OtherFailure) when OtherException is thrown',
          () async {
        //arrange
        when(
          mockPlacesApi.fetchLocationsSuggestions(
            locationName: anyNamed('locationName'),
          ),
        ).thenThrow(
          OtherException(
            message: 'unexpected error',
          ),
        );

        // act
        final result = await locationsRepositoryImpl.fetchLocationsSuggestions(
          locationName: tLocationName,
        );

        // assert
        expect(
          result,
          isA<Left<Failure, LocationEntity>>(),
        );
        expect(
          result.fold(
            (left) => left,
            (right) => null,
          ),
          equals(
            const OtherFailure(
              message: 'unexpected error',
            ),
          ),
        );
        verify(
          mockPlacesApi.fetchLocationsSuggestions(
            locationName: anyNamed('locationName'),
          ),
        ).called(1);
        verifyNoMoreInteractions(
          mockPlacesApi,
        );
      });
    });
  });
}
