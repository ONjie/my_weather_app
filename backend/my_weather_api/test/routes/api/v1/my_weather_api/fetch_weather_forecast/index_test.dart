import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/my_weather_api/models/weather_forecast_model.dart';
import 'package:my_weather_api/src/my_weather_api/repositories/my_weather_api_repository.dart';
import 'package:test/test.dart';

import '../../../../../../routes/api/v1/my_weather_api/fetch_weather_forecast/index.dart'
    as route;

class _MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

class MockMyWeatherApiRepository extends Mock
    implements MyWeatherApiRepository {}

void main() {
  late _MockRequestContext mockRequestContext;
  late MockRequest mockRequest;
  late MockMyWeatherApiRepository mockMyWeatherApiRepository;

  setUp(() {
    mockRequestContext = _MockRequestContext();
    mockRequest = MockRequest();
    mockMyWeatherApiRepository = MockMyWeatherApiRepository();

    when(() => mockRequestContext.request).thenReturn(mockRequest);
    when(() => mockRequestContext.read<MyWeatherApiRepository>()).thenReturn(
      mockMyWeatherApiRepository,
    );
  });

  group('GET /', () {
    const tLat = 13.4531;
    const tLon = -16.5775;

    const tTemp = Temp(
      maxTemp: 23.06,
      minTemp: 19.15,
    );

    const tWeather = Weather(
      description: 'clear sky',
      icon: '01n',
    );

    const tDaily = Daily(
      dateTimestamp: 1739883600,
      sunriseTimestamp: 1739863686,
      sunsetTimestamp: 1739905959,
      temp: tTemp,
      weather: [tWeather],
    );

    const tHourly = Hourly(
      dateTimestamp: 1739919600,
      temp: 21.95,
      weather: [tWeather],
      humidity: 66,
    );

    const tWeatherForecast = WeatherForecastModel(
      hourly: [tHourly, tHourly],
      daily: [tDaily, tDaily],
    );

    test(
        'should return HttpStatus.badRequest and an error message when lat or lon is not provided',
        () async {
      //arrange
      when(
        () => mockRequest.method,
      ).thenReturn(HttpMethod.get);
      when(
        () => mockRequest.uri,
      ).thenReturn(
        Uri(
          queryParameters: {
            'lat': tLat.toString(),
            'lon': '',
          },
        ),
      );

      //act
      final response = await route.onRequest(
        mockRequestContext,
      );
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.badRequest));
      expect(body['error'], equals('lat and lon are required'));
      verify(() => mockRequest.method).called(1);
      verify(() => mockRequest.uri).called(1);
      verifyNoMoreInteractions(mockRequest);
    });

    test(
        'should return HttpStatus.notFound and an error message when fetchWeatherForecast fails',
        () async {
      //arrange
      when(
        () => mockRequest.method,
      ).thenReturn(HttpMethod.get);
      when(
        () => mockRequest.uri,
      ).thenReturn(
        Uri(
          queryParameters: {
            'lat': tLat.toString(),
            'lon': tLon.toString(),
          },
        ),
      );

      when(
        () => mockMyWeatherApiRepository.fetchWeatherForecast(
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          OpenWeatherMapApiFailure(
            message: 'Not found',
          ),
        ),
      );

      //act
      final response = await route.onRequest(
        mockRequestContext,
      );
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.notFound));
      expect(body['error'], equals('Not found'));
      verify(() => mockRequest.method).called(1);
      verify(() => mockRequest.uri).called(1);
      verify(
        () => mockMyWeatherApiRepository.fetchWeatherForecast(
          lat: tLat,
          lon: tLon,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRequest);
      verifyNoMoreInteractions(mockMyWeatherApiRepository);
    });

    test(
        'should return HttpStatus.ok and WeatherForecastModel.toJson when fetchWeatherForecast is successful',
        () async {
      //arrange
      when(
        () => mockRequest.method,
      ).thenReturn(HttpMethod.get);
      when(
        () => mockRequest.uri,
      ).thenReturn(
        Uri(
          queryParameters: {
            'lat': tLat.toString(),
            'lon': tLon.toString(),
          },
        ),
      );

      when(
        () => mockMyWeatherApiRepository.fetchWeatherForecast(
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
        ),
      ).thenAnswer(
        (_) async => const Right(tWeatherForecast),
      );

      //act
      final response = await route.onRequest(
        mockRequestContext,
      );
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        body['hourly'][0]['dt'],
        equals(tWeatherForecast.hourly[0].dateTimestamp),
      );
      expect(
        body['hourly'][0]['temp'],
        equals(tWeatherForecast.hourly[0].temp),
      );
      expect(
        body['hourly'][0]['weather'][0]['description'],
        equals(tWeatherForecast.hourly[0].weather[0].description),
      );
      expect(
        body['hourly'][0]['weather'][0]['icon'],
        equals(tWeatherForecast.hourly[0].weather[0].icon),
      );
      expect(
        body['hourly'][0]['humidity'],
        equals(tWeatherForecast.hourly[0].humidity),
      );
      expect(
        body['daily'][0]['dt'],
        equals(tWeatherForecast.daily[0].dateTimestamp),
      );
      expect(
        body['daily'][0]['sunrise'],
        equals(tWeatherForecast.daily[0].sunriseTimestamp),
      );
      expect(
        body['daily'][0]['sunset'],
        equals(tWeatherForecast.daily[0].sunsetTimestamp),
      );
      expect(
        body['daily'][0]['temp']['max'],
        equals(tWeatherForecast.daily[0].temp.maxTemp),
      );
      expect(
        body['daily'][0]['temp']['min'],
        equals(tWeatherForecast.daily[0].temp.minTemp),
      );
      expect(
        body['daily'][0]['weather'][0]['description'],
        equals(tWeatherForecast.daily[0].weather[0].description),
      );
      expect(
        body['daily'][0]['weather'][0]['icon'],
        equals(tWeatherForecast.daily[0].weather[0].icon),
      );
      verify(() => mockRequest.method).called(1);
      verify(() => mockRequest.uri).called(1);
      verify(
        () => mockMyWeatherApiRepository.fetchWeatherForecast(
          lat: tLat,
          lon: tLon,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRequest);
      verifyNoMoreInteractions(mockMyWeatherApiRepository);
    });
  });
}
