import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/weather_api/models/weather_data.dart';
import 'package:my_weather_api/src/weather_api/repositories/weather_api_repository.dart';
import 'package:test/test.dart';

import '../../../../../../routes/api/v1/weather_api/get_weather_data/index.dart'
    as route;

class _MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockWeatherApiRepository extends Mock implements WeatherApiRepository {}

void main() {
  late _MockRequestContext mockRequestContext;
  late MockRequest mockRequest;
  late MockWeatherApiRepository mockWeatherApiRepository;

  setUp(() {
    mockRequestContext = _MockRequestContext();
    mockRequest = MockRequest();
    mockWeatherApiRepository = MockWeatherApiRepository();

    when(() => mockRequestContext.request).thenReturn(mockRequest);
    when(() => mockRequestContext.read<WeatherApiRepository>())
        .thenReturn(mockWeatherApiRepository);
  });

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

  group('POST /', () {
    test(
        'should return HttpStatus.notFound and an error message when getWeatherData fails',
        () async {
      //arrange
      when(() => mockRequest.method).thenReturn(HttpMethod.post);
      when(() => mockRequest.json()).thenAnswer(
        (_) async => {
          'lat': tLat,
          'long': tLong,
        },
      );
      when(
        () => mockWeatherApiRepository.getWeatherData(
          lat: tLat,
          long: tLong,
        ),
      ).thenAnswer(
        (_) async => const Left(
          WeatherApiFailure(message: 'WeatherApiFailure'),
        ),
      );

      //act
      final response = await route.onRequest(
        mockRequestContext,
      );
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.notFound));
      expect(body['error'], equals('WeatherApiFailure'));
    });

    test(
        'should return HttpStatus.ok and an WeatherData when getWeatherData is successful',
        () async {
      //arrange
      when(() => mockRequest.method).thenReturn(HttpMethod.post);
      when(() => mockRequest.json()).thenAnswer(
        (_) async => {
          'lat': tLat,
          'long': tLong,
        },
      );
      when(
        () => mockWeatherApiRepository.getWeatherData(
          lat: tLat,
          long: tLong,
        ),
      ).thenAnswer(
        (_) async => Right(tWeatherData),
      );

      //act
      final response = await route.onRequest(
        mockRequestContext,
      );
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        body['forecast']['forecastday'][0]['date'],
        equals(tForecastday.date),
      );
      expect(
        body['forecast']['forecastday'][0]['date_epoch'],
        equals(tForecastday.dateEpoch),
      );
      expect(
        body['forecast']['forecastday'][0]['day']['maxtemp_c'],
        equals(tDay.maxtempC),
      );
      expect(
        body['forecast']['forecastday'][0]['day']['mintemp_c'],
        equals(tDay.mintempC),
      );
      expect(
        body['forecast']['forecastday'][0]['day']['condition']['text'],
        equals(tCondition.text),
      );
      expect(
        body['forecast']['forecastday'][0]['day']['condition']['icon'],
        equals(tCondition.icon),
      );
      expect(
        body['forecast']['forecastday'][0]['astro']['sunrise'],
        equals(tAstro.sunrise),
      );
      expect(
        body['forecast']['forecastday'][0]['astro']['sunset'],
        equals(tAstro.sunset),
      );
      expect(
        body['forecast']['forecastday'][0]['astro']['moon_phase'],
        equals(tAstro.moonphase),
      );
      expect(
        body['forecast']['forecastday'][0]['hour'][0]['time_epoch'],
        equals(tHour.timeEpoch),
      );
      expect(
        body['forecast']['forecastday'][0]['hour'][0]['time'],
        equals(tHour.time),
      );
      expect(
        body['forecast']['forecastday'][0]['hour'][0]['temp_c'],
        equals(tHour.tempC),
      );
      expect(
        body['forecast']['forecastday'][0]['hour'][0]['condition']['text'],
        equals(tCondition.text),
      );
      expect(
        body['forecast']['forecastday'][0]['hour'][0]['condition']['icon'],
        equals(tCondition.icon),
      );
    });
  });
}
