import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/weather/domain/entities/location_current_weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/use_cases/fetch_locations_weather_data.dart';

import 'fetch_locations_current_weather_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WeatherRepository>()])
void main() {
  late FetchLocationsCurrentWeather fetchLocationsWeatherData;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    fetchLocationsWeatherData = FetchLocationsCurrentWeather(
      weatherRepository: mockWeatherRepository,
    );
  });

  const tLocationName = 'Banjul';

   const tWeather = WeatherEntity(
      icon: '01n',
    );

    const tCurrent = CurrentEntity(
      dateTimestamp: 1739934864,
      temp: 21.15,
      weather: [tWeather],
    );

    const tLocationCurrentWeather = LocationCurrentWeatherEntity(
      current: tCurrent,
      locationName: tLocationName,
      timezoneOffset: 0,
    );

  provideDummy<Either<Failure, List<LocationCurrentWeatherEntity>>>(
    const Right(
      [tLocationCurrentWeather],
    ),
  );

  test(
      'should return Right(List<LocationCurrentWeatherEntity>) from LocationWeatherRepository',
      () async {
    //arrange
    when(
      mockWeatherRepository.fetchLocationCurrentWeather(),
    ).thenAnswer(
      (_) async => const Right(
        [tLocationCurrentWeather],
      ),
    );

    //act
    final result = await fetchLocationsWeatherData.execute();

    //assert
    expect(result, const Right([tLocationCurrentWeather]));
    verify(
      mockWeatherRepository.fetchLocationCurrentWeather(),
    ).called(1);
    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
