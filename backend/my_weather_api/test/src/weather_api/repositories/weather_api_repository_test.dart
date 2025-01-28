// ignore_for_file: lines_longer_than_80_chars

import 'package:either_dart/either.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/weather_api/datasources/remote_data_sources/weather_api.dart';
import 'package:my_weather_api/src/weather_api/models/location_weather_data.dart';
import 'package:my_weather_api/src/weather_api/models/weather_data.dart';
import 'package:my_weather_api/src/weather_api/repositories/weather_api_repository.dart';
import 'package:test/test.dart';

import 'weather_api_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WeatherApi>()])
const weatherApiErrorMessage = 'WeatherApiError';

void main() {
  late WeatherApiRepositoryImpl weatherApiRepository;
  late MockWeatherApi mockWeatherApi;

  setUp(() {
    mockWeatherApi = MockWeatherApi();
    weatherApiRepository = WeatherApiRepositoryImpl(weatherApi: mockWeatherApi);
  });

  final tLocationWeatherData = LocationWeatherData(
    locationName: 'Banjul',
    localtimeEpoch: 1737504398,
    localtime: '2025-01-22 00:06',
    tempC: 21.3,
    icon: '//cdn.weatherapi.com/weather/64x64/night/113.png',
    country: 'Gambia',
  );

  const tLat = 13.4531;
  const tLong = -16.5775;

  final tCondition = Condition(
    text: 'Clear',
    icon: '//cdn.weatherapi.com/weather/64x64/night/113.png',
  );

  final tDay = Day(
    maxtempC: 26.6,
    mintempC: 21.5,
    condition: tCondition,
  );

  final tAstro = Astro(
    sunrise: '07:34 AM',
    sunset: '07:02 PM',
    moonphase: 'Waning Gibbous',
  );

  final tHour = Hour(
    timeEpoch: 1737331200,
    time: '2025-01-20 00:00',
    tempC: 23.9,
    condition: tCondition,
    humidity: 39,
  );

  final tForecastday = Forecastday(
    date: '2025-01-20',
    dateEpoch: 1737331200,
    day: tDay,
    astro: tAstro,
    hour: [tHour],
  );

  final tWeatherData =
      WeatherData(forecast: Forecast(forecastday: [tForecastday]));

  group('getLocationWeatherData', () {
    test(
        'should return Right(LocationWeatherData) when the response is successful',
        () async {
      //arrange
      when(
        mockWeatherApi.getLocationWeatherData(
          locationName: anyNamed('locationName'),
        ),
      ).thenAnswer((_) async => tLocationWeatherData);

      //act
      final result = await weatherApiRepository.getLocationWeatherData(
        locationName: tLocationWeatherData.locationName,
      );

      //assert
      expect(
        result,
        equals(Right<Failure, LocationWeatherData>(tLocationWeatherData)),
      );
      verify(
        mockWeatherApi.getLocationWeatherData(
          locationName: anyNamed('locationName'),
        ),
      );
      verifyNoMoreInteractions(mockWeatherApi);
    });

    test(
        'should return Left(WeatherApiFailure) when WeatherApiException is thrown',
        () async {
      //arrange
      when(
        mockWeatherApi.getLocationWeatherData(
          locationName: anyNamed('locationName'),
        ),
      ).thenThrow(WeatherApiException(message: weatherApiErrorMessage));

      //act
      final result = await weatherApiRepository.getLocationWeatherData(
        locationName: tLocationWeatherData.locationName,
      );

      //assert
      expect(
        result,
        equals(
          const Left<Failure, LocationWeatherData>(
            WeatherApiFailure(message: weatherApiErrorMessage),
          ),
        ),
      );
      verify(
        mockWeatherApi.getLocationWeatherData(
          locationName: anyNamed('locationName'),
        ),
      );
      verifyNoMoreInteractions(mockWeatherApi);
    });
  });

  group('getWeatherData', () {
    test('should return Right(WeatherData) when the response is successful',
        () async {
      //arrange
      when(
        mockWeatherApi.getWeatherData(
          lat: anyNamed('lat'),
          long: anyNamed('long'),
        ),
      ).thenAnswer((_) async => tWeatherData);

      //act
      final result = await weatherApiRepository.getWeatherData(
        lat: tLat,
        long: tLong,
      );

      //assert
      expect(
        result,
        equals(Right<Failure, WeatherData>(tWeatherData)),
      );
      verify(
        mockWeatherApi.getWeatherData(
          lat: anyNamed('lat'),
          long: anyNamed('long'),
        ),
      );
      verifyNoMoreInteractions(mockWeatherApi);
    });

    test(
        'should return Left(WeatherApiFailure) when WeatherApiException is thrown',
        () async {
      //arrange
      when(
        mockWeatherApi.getWeatherData(
          lat: anyNamed('lat'),
          long: anyNamed('long'),
        ),
      ).thenThrow(WeatherApiException(message: weatherApiErrorMessage));

      //act
      final result = await weatherApiRepository.getWeatherData(
        lat: tLat,
        long: tLong,
      );

      //assert
      expect(
        result,
        equals(
          const Left<Failure, WeatherData>(
            WeatherApiFailure(message: weatherApiErrorMessage),
          ),
        ),
      );
      verify(
        mockWeatherApi.getWeatherData(
          lat: anyNamed('lat'),
          long: anyNamed('long'),
        ),
      );
      verifyNoMoreInteractions(mockWeatherApi);
    });
  });
}
