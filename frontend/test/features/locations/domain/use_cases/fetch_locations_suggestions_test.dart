import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/locations/domain/entities/location_entity.dart';
import 'package:weather_app/features/locations/domain/repositories/locations_repository.dart';
import 'package:weather_app/features/locations/domain/use_cases/fetch_locations_suggestions.dart';

import 'fetch_locations_suggestions_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LocationsRepository>()])
void main() {
  late FetchLocationsSuggestions fetchLocationsSuggestions;
  late MockLocationsRepository mockLocationsRepository;

  setUp(() {
    mockLocationsRepository = MockLocationsRepository();
    fetchLocationsSuggestions = FetchLocationsSuggestions(
      locationsRepository: mockLocationsRepository,
    );
  });

  const tLocationName = 'Banjul';

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

  provideDummy<Either<Failure, LocationEntity>>(const Right(tLocation));

  test('should return Right(LocationEntity) from LocationsRepository',
      () async {
    // arrange
    when(
      mockLocationsRepository.fetchLocationsSuggestions(
        locationName: anyNamed('locationName'),
      ),
    ).thenAnswer((_) async => const Right(tLocation));
    // act
    final result =
        await fetchLocationsSuggestions.execute(locationName: tLocationName);
    // assert
    expect(result, const Right(tLocation));
    verify(
      mockLocationsRepository.fetchLocationsSuggestions(
        locationName: anyNamed('locationName'),
      ),
    );
    verifyNoMoreInteractions(mockLocationsRepository);
  });
}
