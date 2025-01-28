// ignore_for_file: inference_failure_on_function_invocation

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/core/utils/weather_api_urls.dart';
import 'package:my_weather_api/env/env.dart';
import 'package:my_weather_api/src/weather_api/datasources/remote_data_sources/weather_api.dart';
import 'package:my_weather_api/src/weather_api/models/location_weather_data.dart';
import 'package:my_weather_api/src/weather_api/models/weather_data.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'weather_api_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late WeatherApiImpl weatherApiImpl;
  late MockDio dio;

  setUp(() {
    dio = MockDio();
    weatherApiImpl = WeatherApiImpl(dio: dio);
  });

  void setUpMockDioSuccess200({
    required String url,
    required Map<String, dynamic> responseJson,
  }) {
    when(dio.get(any)).thenAnswer(
      (_) async => Response(
        data: responseJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: url),
      ),
    );
  }

  void setUpMockDioFailure404({required String url}) {
    when(dio.get(url)).thenThrow(
      DioException(
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: url),
        ),
        requestOptions: RequestOptions(path: url),
      ),
    );
  }

  group('getLocationWeatherData', () {
    final tLocationWeatherData = LocationWeatherData(
      locationName: 'Banjul',
      localtimeEpoch: 1737504398,
      localtime: '2025-01-22 00:06',
      tempC: 21.3,
      icon: '//cdn.weatherapi.com/weather/64x64/night/113.png',
      country: 'Gambia',
    );

    final tUrl =
        '$baseUrl$currentWeather?key=${Env.apiKey}&q=${tLocationWeatherData.locationName}&days=7';
    final tResponseJson = json.decode(fixture('location_weather_data.json'))
        as Map<String, dynamic>;

    test('should return LocationWeatherData when the reponse statuCode is 200',
        () async {
      //arrange
      setUpMockDioSuccess200(url: tUrl, responseJson: tResponseJson);

      //act
      final result = await weatherApiImpl.getLocationWeatherData(
        locationName: tLocationWeatherData.locationName,
      );

      //assert
      expect(result, isA<LocationWeatherData>());
      expect(result.locationName, equals(tLocationWeatherData.locationName));
      expect(result.country, equals(tLocationWeatherData.country));
      expect(result.localtime, equals(tLocationWeatherData.localtime));
      expect(
        result.localtimeEpoch,
        equals(tLocationWeatherData.localtimeEpoch),
      );
      expect(result.tempC, equals(tLocationWeatherData.tempC));
      expect(result.icon, equals(tLocationWeatherData.icon));
    });

    test('should throw WeatherApiException when the response statuCode is 404',
        () async {
      //arrange
      setUpMockDioFailure404(url: tUrl);

      //act
      final call = weatherApiImpl.getLocationWeatherData;

      //assert
      expect(
        () => call(locationName: tLocationWeatherData.locationName),
        throwsA(isA<WeatherApiException>()),
      );
    });
  });

  group('getWeatherData', () {
    const tLat = 13.4531;
    const tLong = -16.5775;
    final tUrl = '$baseUrl$forecast?key=${Env.apiKey}&q=$tLat,$tLong&days=7';

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

    final tResponseJson =
        json.decode(fixture('weather_data.json')) as Map<String, dynamic>;

    test('should return WeatherData when response statusCode is 200', () async {
      //arrange
      setUpMockDioSuccess200(url: tUrl, responseJson: tResponseJson);

      //act
      final result =
          await weatherApiImpl.getWeatherData(lat: tLat, long: tLong);

      //assert
      expect(result, isA<WeatherData>());
      expect(result.forecast.forecastday[0].date, tForecastday.date);
      expect(result.forecast.forecastday[0].astro.sunrise, tAstro.sunrise);
      expect(result.forecast.forecastday[0].day.maxtempC, tDay.maxtempC);
      expect(result.forecast.forecastday[0].hour[0].time, tHour.time);
    });

    test('should throw WeatherApiException when response statusCode is 404',
        () async {
      //arrange
      setUpMockDioFailure404(
        url: tUrl,
      );

      //act
      final call = weatherApiImpl.getWeatherData;

      //assert
      expect(
        () => call(lat: tLat, long: tLong),
        throwsA(isA<WeatherApiException>()),
      );
    });
  });
}
