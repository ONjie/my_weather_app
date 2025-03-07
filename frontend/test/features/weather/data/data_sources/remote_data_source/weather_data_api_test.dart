import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/exceptions/exceptions.dart';
import 'package:weather_app/features/weather/data/data_sources/remote_data_source/weather_api.dart';
import 'package:weather_app/features/weather/data/models/location_current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/weather_forecast_model.dart'
    as prefix;

import '../../../../../fixtures/fixture_reader.dart';
import 'weather_data_api_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late WeatherApiImpl weatherDataApiImpl;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    weatherDataApiImpl = WeatherApiImpl(dio: mockDio);
  });

  const tLat = 13.4531;
  const tLon = -16.5775;
  group('fetchWeatherForecast', () {
    const tTemp = prefix.TempModel(
      maxTemp: 23.06,
      minTemp: 19.15,
    );

    const tWeather = prefix.WeatherModel(
      description: 'clear sky',
      icon: '01n',
    );

    const tDaily = prefix.DailyModel(
      dateTimestamp: 1739883600,
      sunriseTimestamp: 1739863686,
      sunsetTimestamp: 1739905959,
      temp: tTemp,
      weather: [tWeather],
    );

    const tHourly = prefix.HourlyModel(
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
        'should perform a GET request on the URL and return WeatherForecastModel if the statusCode == HttpStatus.ok',
        () async {
      // arrange
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: HttpStatus.ok,
          data: json.decode(
                  fixture('my_weather_api_weather_forecast_response.json'))
              as Map<String, dynamic>,
        ),
      );

      // act
      final result = await weatherDataApiImpl.fetchWeatherForecast(
        lat: tLat,
        lon: tLon,
      );

      // assert
      expect(result, isA<prefix.WeatherForecastModel>());
      expect(result.hourly, tWeatherForecast.hourly);
      expect(result.daily, tWeatherForecast.daily);

      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test(
        'should perform a GET request on the URL and throw a ServerException if the statusCode != HttpStatus.ok',
        () async {
      // arrange
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: HttpStatus.notFound,
          data: {'error': 'Not Found'},
        ),
      );

      // act
      final call = weatherDataApiImpl.fetchWeatherForecast;

      // assert
      expect(
        () => call(lat: tLat, lon: tLon),
        throwsA(isA<ServerException>()),
      );

      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test(
        'should throw an OtherException if the Exception is not a ServerException',
        () async {
      // arrange
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenThrow(Exception('error'));

      // act
      final call = weatherDataApiImpl.fetchWeatherForecast;

      // assert
      expect(
        () => call(lat: tLat, lon: tLon),
        throwsA(isA<OtherException>()),
      );

      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });
  });

  group('fetchLocationCurrentWeather', () {
    const tLocationName = 'Banjul';

    const tWeather = WeatherModel(
      icon: '01n',
    );

    const tCurrent = CurrentModel(
      dateTimestamp: 1739934864,
      temp: 21.15,
      weather: [tWeather],
    );

    const tLocationCurrentWeather = LocationCurrentWeatherModel(
      timezoneOffset: 0,
      current: tCurrent,
      locationName: tLocationName,
    );

    test(
        'should perform a GET request on the URL and return LocationCurrentWeatherModel if the statusCode == HttpStatus.ok',
        () async {
      // arrange
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: HttpStatus.ok,
          data: json.decode(
                  fixture('my_weather_api_current_weather_response.json'))
              as Map<String, dynamic>,
        ),
      );

      // act
      final result = await weatherDataApiImpl.fetchLocationCurrentWeather(
        locationName: tLocationName,
        lat: tLat,
        lon: tLon,
      );

      // assert
      expect(result, isA<LocationCurrentWeatherModel>());
      expect(result.current, tLocationCurrentWeather.current);

      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test(
        'should perform a GET request on the URL and throw a ServerException if the statusCode != HttpStatus.ok',
        () async {
      // arrange
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: HttpStatus.notFound,
          data: {'error': 'Not Found'},
        ),
      );

      // act
      final call = weatherDataApiImpl.fetchLocationCurrentWeather;

      // assert
      expect(
          () => call(
                locationName: tLocationName,
                lat: tLat,
                lon: tLon,
              ),
          throwsA(isA<ServerException>()));

      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test(
        'should throw an OtherException if the Exception is not a ServerException',
        () async {
      // arrange
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenThrow(Exception('error'));

      // act
      final call = weatherDataApiImpl.fetchLocationCurrentWeather;

      // assert
      expect(
          () => call(
                locationName: tLocationName,
                lat: tLat,
                lon: tLon,
              ),
          throwsA(isA<OtherException>()));
      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });
  });
}
