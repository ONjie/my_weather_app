import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';
import 'package:weather_app/features/locations/domain/repositories/locations_repository.dart';
import 'package:weather_app/features/locations/domain/use_cases/fetch_favorite_locations.dart';

import 'fetch_favorite_locations_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LocationsRepository>()])
void main() {
  late FetchFavoriteLocations fetchFavoriteLocations;
  late MockLocationsRepository mockLocationsRepository;

  setUp(() {
    mockLocationsRepository = MockLocationsRepository();
    fetchFavoriteLocations = FetchFavoriteLocations(
      favoriteLocationsRepository: mockLocationsRepository,
    );
  });

  const tFavoriteLocation = FavoriteLocationEntity(
    locationName: 'Banjul',
    country: 'Gambia',
    latitude: 13.4531,
    longitude: -16.5775,
  );

  provideDummy<Either<Failure, List<FavoriteLocationEntity>>>(
      const Right([tFavoriteLocation]));

  test('should return Right(List<LocationsEntity>) from LocationsRepository',
      () async {
    //arrange
    when(mockLocationsRepository.fetchFavoriteLocations()).thenAnswer(
      (_) async => const Right([tFavoriteLocation]),
    );

    //act
    final result = await fetchFavoriteLocations.execute();

    //assert
    expect(result, equals(const Right([tFavoriteLocation])));
    verify(mockLocationsRepository.fetchFavoriteLocations()).called(1);
    verifyNoMoreInteractions(mockLocationsRepository);
  });
}
