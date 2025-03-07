import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/locations/domain/repositories/locations_repository.dart';
import 'package:weather_app/features/locations/domain/use_cases/delete_favorite_location.dart';

import 'delete_favorite_location_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LocationsRepository>()])
void main() {
  late DeleteFavoriteLocation deleteFavoriteLocation;
  late MockLocationsRepository mockLocationsRepository;

  setUp(() {
    mockLocationsRepository = MockLocationsRepository();
    deleteFavoriteLocation = DeleteFavoriteLocation(
      favoriteLocationsRepository: mockLocationsRepository,
    );
  });

  provideDummy<Either<Failure, bool>>(const Right(true));

  test('should return Right(bool) from LocationsRepository', () async {
    //arrange
    when(
      mockLocationsRepository.deleteFavoriteLocation(
        id: anyNamed('id'),
      ),
    ).thenAnswer(
      (_) async => const Right(true),
    );

    //act
    final result = await deleteFavoriteLocation.execute(id: 1);

    //assert
    expect(result, equals(const Right(true)));
    verify(
      mockLocationsRepository.deleteFavoriteLocation(
        id: anyNamed('id'),
      ),
    ).called(1);
    verifyNoMoreInteractions(mockLocationsRepository);
  });
}
