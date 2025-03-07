import 'package:either_dart/either.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/my_weather_api/data_sources/remote_data_source/open_weather_map_api.dart';
import 'package:my_weather_api/src/my_weather_api/models/location_current_weather_model.dart';
import 'package:my_weather_api/src/my_weather_api/models/weather_forecast_model.dart'
    as prefix;
import 'package:my_weather_api/src/my_weather_api/repositories/my_weather_api_repository.dart';
import 'package:test/test.dart';

import 'my_weather_api_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OpenWeatherMapApi>()])
void main() {
  late MyWeatherApiRepositoryImpl myWeatherApiRepositoryImpl;
  late MockOpenWeatherMapApi mockOpenWeatherMapApi;

  setUp(() {
    mockOpenWeatherMapApi = MockOpenWeatherMapApi();
    myWeatherApiRepositoryImpl = MyWeatherApiRepositoryImpl(
      openWeatherMapApi: mockOpenWeatherMapApi,
    );
  });

  const tLat = 13.4531;
  const tLon = -16.5775;

  group('fetchWeatherForecast', () {
    const tTemp = prefix.Temp(
      maxTemp: 23.06,
      minTemp: 19.15,
    );

    const tWeather = prefix.Weather(
      description: 'clear sky',
      icon: '01n',
    );

    const tDaily = prefix.Daily(
      dateTimestamp: 1739883600,
      sunriseTimestamp: 1739863686,
      sunsetTimestamp: 1739905959,
      temp: tTemp,
      weather: [tWeather],
    );

    const tHourly = prefix.Hourly(
      dateTimestamp: 1739919600,
      temp: 21.95,
      weather: [tWeather],
      humidity: 66,
    );

    const tWeatherForecast = prefix.WeatherForecastModel(
      hourly: [tHourly, tHourly],
      daily: [tDaily, tDaily],
    );

    test(
        'should return Right(WeatherForecastModel) when response is successful',
        () async {
      //arrange
      when(
        mockOpenWeatherMapApi.fetchWeatherForecast(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).thenAnswer((_) async => tWeatherForecast);

      //act
      final result = await myWeatherApiRepositoryImpl.fetchWeatherForecast(
        lat: tLat,
        lon: tLon,
      );

      //assert
      expect(
        result,
        isA<Right<Failure, prefix.WeatherForecastModel>>(),
      );
      expect(
        result.right,
        equals(
          tWeatherForecast,
        ),
      );
      verify(
        mockOpenWeatherMapApi.fetchWeatherForecast(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).called(1);
      verifyNoMoreInteractions(
        mockOpenWeatherMapApi,
      );
    });

    test(
        'should return Left(OpenWeatherMapApiFailure) when OpenWeatherMapApiException is thrown',
        () async {
      //arrange
      when(
        mockOpenWeatherMapApi.fetchWeatherForecast(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).thenThrow(
        OpenWeatherMapApiException(
          message: 'Not Found',
        ),
      );

      //act
      final result = await myWeatherApiRepositoryImpl.fetchWeatherForecast(
        lat: tLat,
        lon: tLon,
      );

      //assert
      expect(
        result,
        isA<Left<Failure, prefix.WeatherForecastModel>>(),
      );
      expect(
        result.left,
        equals(
          const OpenWeatherMapApiFailure(
            message: 'Not Found',
          ),
        ),
      );
      verify(
        mockOpenWeatherMapApi.fetchWeatherForecast(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).called(1);
      verifyNoMoreInteractions(
        mockOpenWeatherMapApi,
      );
    });

    test('should return Left(OtherFailure) when OtherException is thrown',
        () async {
      //arrange
      when(
        mockOpenWeatherMapApi.fetchWeatherForecast(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).thenThrow(
        OtherException(
          message: 'Unauthorized',
        ),
      );

      //act
      final result = await myWeatherApiRepositoryImpl.fetchWeatherForecast(
        lat: tLat,
        lon: tLon,
      );

      //assert
      expect(
        result,
        isA<Left<Failure, prefix.WeatherForecastModel>>(),
      );
      expect(
        result.left,
        equals(
          const OtherFailure(
            message: 'Unauthorized',
          ),
        ),
      );
      verify(
        mockOpenWeatherMapApi.fetchWeatherForecast(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).called(1);
      verifyNoMoreInteractions(
        mockOpenWeatherMapApi,
      );
    });
  });

  group('fetchLocationCurrentWeather', () {
    const tWeather = Weather(
      icon: '01n',
    );

    const tCurrent = Current(
      dateTimestamp: 1739934864,
      temp: 21.15,
      weather: [tWeather],
    );

    const tLocationCurrentWeather = LocationCurrentWeatherModel(
      timezoneOffset: 0,
      current: tCurrent,
    );

    test(
        'should return Right(LocationCurrentWeatherModel) when response is successful',
        () async {
      //arrange
      when(
        mockOpenWeatherMapApi.fetchLocationCurrentWeather(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).thenAnswer(
        (_) async => tLocationCurrentWeather,
      );

      //act
      final result =
          await myWeatherApiRepositoryImpl.fetchLocationCurrentWeather(
        lat: tLat,
        lon: tLon,
      );

      //assert
      expect(
        result,
        isA<Right<Failure, LocationCurrentWeatherModel>>(),
      );
      expect(
        result.right,
        equals(
          tLocationCurrentWeather,
        ),
      );
      verify(
        mockOpenWeatherMapApi.fetchLocationCurrentWeather(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).called(1);
      verifyNoMoreInteractions(
        mockOpenWeatherMapApi,
      );
    });

    test(
        'should return Left(OpenWeatherMapApiFailure) when OpenWeatherMapApiException is thrown',
        () async {
      //arrange
      when(
        mockOpenWeatherMapApi.fetchLocationCurrentWeather(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).thenThrow(
        OpenWeatherMapApiException(
          message: 'Not Found',
        ),
      );

      //act
      final result =
          await myWeatherApiRepositoryImpl.fetchLocationCurrentWeather(
        lat: tLat,
        lon: tLon,
      );

      //assert
      expect(
        result,
        isA<Left<Failure, LocationCurrentWeatherModel>>(),
      );
      expect(
        result.left,
        equals(
          const OpenWeatherMapApiFailure(
            message: 'Not Found',
          ),
        ),
      );
      verify(
        mockOpenWeatherMapApi.fetchLocationCurrentWeather(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).called(1);
      verifyNoMoreInteractions(
        mockOpenWeatherMapApi,
      );
    });

    test('should return Left(OtherFailure) when OtherException is thrown',
        () async {
      //arrange
      when(
        mockOpenWeatherMapApi.fetchLocationCurrentWeather(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).thenThrow(
        OtherException(
          message: 'Unauthorized',
        ),
      );

      //act
      final result =
          await myWeatherApiRepositoryImpl.fetchLocationCurrentWeather(
        lat: tLat,
        lon: tLon,
      );

      //assert
      expect(
        result,
        isA<Left<Failure, LocationCurrentWeatherModel>>(),
      );
      expect(
        result.left,
        equals(
          const OtherFailure(
            message: 'Unauthorized',
          ),
        ),
      );
      verify(
        mockOpenWeatherMapApi.fetchLocationCurrentWeather(
          lat: anyNamed('lat'),
          lon: anyNamed('lon'),
        ),
      ).called(1);
      verifyNoMoreInteractions(
        mockOpenWeatherMapApi,
      );
    });
  });
}
