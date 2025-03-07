import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:either_dart/either.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/my_weather_api/models/location_current_weather_model.dart';
import 'package:my_weather_api/src/my_weather_api/repositories/my_weather_api_repository.dart';
import 'package:test/test.dart';

import '../../../../../../routes/api/v1/my_weather_api/fetch_location_current_weather/index.dart'
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
    const tLocationName = 'Banjul';

    const tWeather = Weather(
      icon: '01n',
    );

    const tCurrent = Current(
      dateTimestamp: 1739934864,
      temp: 21.15,
      weather: [tWeather],
    );

    const tLocationCurrentWeather = LocationCurrentWeatherModel(
      current: tCurrent, timezoneOffset: 0,
    );

    test(
        'should return HttpStatus.badRequest and an error message when lat or lon or location name is not provided',
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
            'location_name': '',
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
      expect(body['error'], equals('lat, lon and location name are required'));
      verify(() => mockRequest.method).called(1);
      verify(() => mockRequest.uri).called(1);
      verifyNoMoreInteractions(mockRequest);
    });

    test(
        'should return HttpStatus.notFound and an error message when fetchLocationCurrentWeather fails',
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
            'location_name': tLocationName,
          },
        ),
      );

      when(
        () => mockMyWeatherApiRepository.fetchLocationCurrentWeather(
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
        () => mockMyWeatherApiRepository.fetchLocationCurrentWeather(
          lat: tLat,
          lon: tLon,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRequest);
      verifyNoMoreInteractions(mockMyWeatherApiRepository);
    });

    test(
        'should return HttpStatus.ok and a Json when fetchWeatherForecast is successful',
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
            'location_name': tLocationName,
          },
        ),
      );

      when(
        () => mockMyWeatherApiRepository.fetchLocationCurrentWeather(
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
        ),
      ).thenAnswer(
        (_) async => const Right(tLocationCurrentWeather),
      );

      //act
      final response = await route.onRequest(
        mockRequestContext,
      );
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;

      //assert
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        body['location_name'],
        equals(tLocationName),
      );
      expect(
        body['current_weather'],
        equals(tLocationCurrentWeather.toJson()),
      );
      expect(
        body['current_weather']['current']['dt'],
        equals(tLocationCurrentWeather.current.dateTimestamp),
      );
      expect(
        body['current_weather']['current']['temp'],
        equals(tLocationCurrentWeather.current.temp),
      );
      expect(
        body['current_weather']['current']['weather'][0]['icon'],
        equals(tLocationCurrentWeather.current.weather[0].icon),
      );

      verify(() => mockRequest.method).called(1);
      verify(() => mockRequest.uri).called(1);
      verify(
        () => mockMyWeatherApiRepository.fetchLocationCurrentWeather(
          lat: tLat,
          lon: tLon,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRequest);
      verifyNoMoreInteractions(mockMyWeatherApiRepository);
    });
  });
}
