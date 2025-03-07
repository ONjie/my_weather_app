import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';
import 'package:weather_app/features/locations/domain/repositories/locations_repository.dart';
import 'package:weather_app/features/locations/domain/use_cases/add_favorite_location.dart';

import 'add_favorite_location_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LocationsRepository>()])
void main() {
  late AddFavoriteLocation addFavoriteLocation;
  late MockLocationsRepository mockLocationsRepository;

  setUp(() {
    mockLocationsRepository = MockLocationsRepository();
    addFavoriteLocation = AddFavoriteLocation(
      favoriteLocationsRepository: mockLocationsRepository,
    );
  });

  const tFavoriteLocation = FavoriteLocationEntity(
    locationName: 'Banjul',
    country: 'Gambia',
    latitude: 13.4531,
    longitude: -16.5775,
  );

  provideDummy<Either<Failure, int>>(const Right(1));

  test('should return Right(int) from LocationsRepository', () async {
    //arrange
    when(
      mockLocationsRepository.addFavoriteLocation(
        favoriteLocation: anyNamed('favoriteLocation'),
      ),
    ).thenAnswer(
      (_) async => const Right(1),
    );

    //act
    final result =
        await addFavoriteLocation.execute(favoriteLocation: tFavoriteLocation);

    //assert
    expect(result, equals(const Right(1)));
    verify(
      mockLocationsRepository.addFavoriteLocation(
        favoriteLocation: anyNamed('favoriteLocation'),
      ),
    ).called(1);
    verifyNoMoreInteractions(mockLocationsRepository);
  });
}
