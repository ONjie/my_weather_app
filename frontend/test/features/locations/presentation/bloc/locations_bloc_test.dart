import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';
import 'package:weather_app/features/locations/domain/entities/location_entity.dart';
import 'package:weather_app/features/locations/domain/use_cases/add_favorite_location.dart';
import 'package:weather_app/features/locations/domain/use_cases/delete_favorite_location.dart';
import 'package:weather_app/features/locations/domain/use_cases/fetch_favorite_locations.dart';
import 'package:weather_app/features/locations/domain/use_cases/fetch_locations_suggestions.dart';
import 'package:weather_app/features/locations/presentation/bloc/locations_bloc.dart';

import 'locations_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AddFavoriteLocation>()])
@GenerateNiceMocks([MockSpec<FetchFavoriteLocations>()])
@GenerateNiceMocks([MockSpec<DeleteFavoriteLocation>()])
@GenerateNiceMocks([MockSpec<FetchLocationsSuggestions>()])
void main() {
  late LocationsBloc locationsBloc;
  late MockAddFavoriteLocation mockAddFavoriteLocation;
  late MockFetchFavoriteLocations mockFetchFavoriteLocations;
  late MockDeleteFavoriteLocation mockDeleteFavoriteLocation;
  late MockFetchLocationsSuggestions mockFetchLocationsSuggestions;

  setUp(() {
    mockAddFavoriteLocation = MockAddFavoriteLocation();
    mockFetchFavoriteLocations = MockFetchFavoriteLocations();
    mockDeleteFavoriteLocation = MockDeleteFavoriteLocation();
    mockFetchLocationsSuggestions = MockFetchLocationsSuggestions();

    locationsBloc = LocationsBloc(
      addFavoriteLocation: mockAddFavoriteLocation,
      fetchFavoriteLocations: mockFetchFavoriteLocations,
      deleteFavoriteLocation: mockDeleteFavoriteLocation,
      fetchLocationsSuggestions: mockFetchLocationsSuggestions,
    );
  });

  const tFavoriteLocationList = [
    FavoriteLocationEntity(
      id: 1,
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    )
  ];

  const tProperties = PropertiesEntity(
    locationName: 'Banjul',
    country: 'Gambia',
    formatted: 'Banjul, Gambia',
    latitude: 13.4531,
    longitude: -16.5775,
  );

  const tFeature = FeatureEntity(properties: tProperties);

  const tLocation = LocationEntity(
    features: [tFeature, tFeature],
  );

  provideDummy<Either<Failure, int>>(
    const Right(1),
  );
  provideDummy<Either<Failure, bool>>(
    const Right(true),
  );
  provideDummy<Either<Failure, List<FavoriteLocationEntity>>>(
    const Right(tFavoriteLocationList),
  );
  provideDummy<Either<Failure, LocationEntity>>(
    const Right(tLocation),
  );

  group('_addFavoriteLocation', () {
    const tFavoriteLocation = FavoriteLocationEntity(
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    );

    blocTest(
      'should emit[AddFavoriteLocationError] when unsuccessful',
      setUp: () {
        when(
          mockAddFavoriteLocation.execute(
            favoriteLocation: anyNamed('favoriteLocation'),
          ),
        ).thenAnswer(
          (_) async => const Left(
              DatabaseFailure(message: 'Failed to add favorite location.')),
        );
      },
      build: () => locationsBloc,
      act: (bloc) => locationsBloc.add(
        const AddFavoriteLocationEvent(
          favoriteLocation: tFavoriteLocation,
        ),
      ),
      expect: () => <LocationsState>[
        const LocationsState(
          locationStatus: LocationStatus.addFavoriteLocationError,
          errorMessage: 'Failed to add favorite location.',
        ),
      ],
    );

    blocTest(
      'should emit[FavoriteLocationAdded] when successful',
      setUp: () {
        when(
          mockAddFavoriteLocation.execute(
            favoriteLocation: anyNamed('favoriteLocation'),
          ),
        ).thenAnswer(
          (_) async => const Right(1),
        );
      },
      build: () => locationsBloc,
      act: (bloc) => locationsBloc.add(
        const AddFavoriteLocationEvent(
          favoriteLocation: tFavoriteLocation,
        ),
      ),
      expect: () => <LocationsState>[
        const LocationsState(
          locationStatus: LocationStatus.favoriteLocationAdded,
        ),
      ],
    );
  });

  group('_fetchFavoriteLocations', () {
    blocTest(
      'should emit[FavoriteLocationsLoading, FetchFavoriteLocationsError] when unsuccessful',
      setUp: () {
        when(
          mockFetchFavoriteLocations.execute(),
        ).thenAnswer(
          (_) async => const Left(
              DatabaseFailure(message: 'No favorite locations found.')),
        );
      },
      build: () => locationsBloc,
      act: (bloc) => locationsBloc.add(FetchFavoriteLocationsEvent()),
      expect: () => [
        const LocationsState(
          locationStatus: LocationStatus.favoriteLocationsLoading,
        ),
        const LocationsState(
          locationStatus: LocationStatus.fetchFavoriteLocationsError,
          errorMessage: 'No favorite locations found.',
        ),
      ],
    );

    blocTest(
      'should emit[FavoriteLocationsLoading, FavoriteLocationsLoaded] when successful',
      setUp: () {
        when(
          mockFetchFavoriteLocations.execute(),
        ).thenAnswer(
          (_) async => const Right(tFavoriteLocationList),
        );
      },
      build: () => locationsBloc,
      act: (bloc) => locationsBloc.add(FetchFavoriteLocationsEvent()),
      expect: () => [
        const LocationsState(
          locationStatus: LocationStatus.favoriteLocationsLoading,
        ),
        const LocationsState(
            locationStatus: LocationStatus.favoriteLocationsLoaded,
            favoriteLocations: tFavoriteLocationList),
      ],
    );
  });

  group('_deleteFavoriteLocation', () {
    const tId = 1;

    blocTest(
      'should emit[DeleteFavoriteLocationError] when unsuccessful',
      setUp: () {
        when(
          mockDeleteFavoriteLocation.execute(
            id: anyNamed('id'),
          ),
        ).thenAnswer(
          (_) async => const Left(
              DatabaseFailure(message: 'Failed to delete favorite location.')),
        );
      },
      build: () => locationsBloc,
      act: (bloc) => locationsBloc.add(
        const DeleteFavoriteLocationEvent(
          id: tId,
        ),
      ),
      expect: () => <LocationsState>[
        const LocationsState(
          locationStatus: LocationStatus.deleteFavoriteLocationError,
          errorMessage: 'Failed to delete favorite location.',
        ),
      ],
    );

    blocTest(
      'should emit[FavoriteLocationDeleted] when successful',
      setUp: () {
        when(
          mockDeleteFavoriteLocation.execute(
            id: anyNamed('id'),
          ),
        ).thenAnswer(
          (_) async => const Right(true),
        );
      },
      build: () => locationsBloc,
      act: (bloc) => locationsBloc.add(
        const DeleteFavoriteLocationEvent(
          id: tId,
        ),
      ),
      expect: () => <LocationsState>[
        const LocationsState(
          locationStatus: LocationStatus.favoriteLocationDeleted,
        ),
      ],
    );
  });

  group('_onFetchLocationsSuggestions', () {
    const tLocationName = 'Banjul';

    blocTest(
      'should emit[LocationSuggestionsLoading, LocationSuggestionsError] when unsuccessful',
      setUp: () {
        when(
          mockFetchLocationsSuggestions.execute(
            locationName: anyNamed('locationName'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Failed to fetch locations.'),
          ),
        );
      },
      build: () => locationsBloc,
      act: (bloc) => locationsBloc.add(
        const FetchLocationsSuggestionsEvent(
          locationName: tLocationName,
        ),
      ),
      expect: () => <LocationsState>[
        const LocationsState(
          locationStatus: LocationStatus.locationSuggestionsLoading,
        ),
        const LocationsState(
          locationStatus: LocationStatus.fetchLocationSuggestionsError,
          errorMessage: 'Failed to fetch locations.',
        ),
      ],
    );

    blocTest(
      'should emit[LocationSuggestionsLoading, LocationSuggestionsLoaded] when successful',
      setUp: () {
        when(
          mockFetchLocationsSuggestions.execute(
            locationName: anyNamed('locationName'),
          ),
        ).thenAnswer(
          (_) async => const Right(tLocation),
        );
      },
      build: () => locationsBloc,
      act: (bloc) => locationsBloc.add(
        const FetchLocationsSuggestionsEvent(
          locationName: tLocationName,
        ),
      ),
      expect: () => <LocationsState>[
        const LocationsState(
          locationStatus: LocationStatus.locationSuggestionsLoading,
        ),
        const LocationsState(
          locationStatus: LocationStatus.locationSuggestionsLoaded,
          locationSuggestions: tLocation,
        ),
      ],
    );
  });
}
