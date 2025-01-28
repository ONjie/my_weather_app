import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/weather_api/models/location_weather_data.dart';
import 'package:my_weather_api/src/weather_api/repositories/weather_api_repository.dart';
import 'package:test/test.dart';

import '../../../../../../routes/api/v1/weather_api/get_location_weather_data/[location_name].dart'
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

  final tLocationWeatherData = LocationWeatherData(
    locationName: 'Banjul',
    localtimeEpoch: 1737504398,
    localtime: '2025-01-22 00:06',
    tempC: 21.3,
    icon: '//cdn.weatherapi.com/weather/64x64/night/113.png',
    country: 'Gambia',
  );

  group('GET /', () {
    test(
        'should return HttpStatus.notFound and an error message when getLocationWeatherData fails',
        () async {
      //arrange
      when(() => mockRequest.method).thenReturn(HttpMethod.get);
      when(() => mockRequest.json()).thenAnswer(
        (_) async => {
          'location_name': tLocationWeatherData.locationName,
        },
      );
      when(
        () => mockWeatherApiRepository.getLocationWeatherData(
          locationName: tLocationWeatherData.locationName,
        ),
      ).thenAnswer(
        (_) async => const Left(
          WeatherApiFailure(message: 'WeatherApiFailure'),
        ),
      );

      //act
      final response = await route.onRequest(
        mockRequestContext,
        tLocationWeatherData.locationName,
      );
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.notFound));
      expect(body['error'], equals('WeatherApiFailure'));
    });

    test(
        'should return HttpStatus.ok and LocationWeatherData when getLocationWeatherData is successful',
        () async {
      when(() => mockRequest.method).thenReturn(HttpMethod.get);
      when(() => mockRequest.json()).thenAnswer(
        (_) async => {
          'location_name': tLocationWeatherData.locationName,
        },
      );
      when(
        () => mockWeatherApiRepository.getLocationWeatherData(
          locationName: tLocationWeatherData.locationName,
        ),
      ).thenAnswer(
        (_) async => Right(tLocationWeatherData),
      );

      //act
      final response = await route.onRequest(
        mockRequestContext,
        tLocationWeatherData.locationName,
      );
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(body['location_name'], equals(tLocationWeatherData.locationName));
      expect(
        body['localtime_epoch'],
        equals(tLocationWeatherData.localtimeEpoch),
      );
      expect(body['localtime'], equals(tLocationWeatherData.localtime));
      expect(body['temp_c'], equals(tLocationWeatherData.tempC));
      expect(body['icon'], equals(tLocationWeatherData.icon));
      expect(body['country'], equals(tLocationWeatherData.country));
    });
  });
}
