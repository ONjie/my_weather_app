import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/src/my_weather_api/data_sources/remote_data_source/open_weather_map_api.dart';
import 'package:my_weather_api/src/my_weather_api/models/location_current_weather_model.dart';
import 'package:my_weather_api/src/my_weather_api/models/weather_forecast_model.dart'
    as prefix;
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'open_weather_map_api_test.mocks.dart';

typedef MapJson = Map<String, dynamic>;

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late OpenWeatherMapApiImpl openWeatherMapApiImpl;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    openWeatherMapApiImpl = OpenWeatherMapApiImpl(dio: mockDio);
  });

  void setUpDioSuccess200({required MapJson responseJson}) {
    when(
      mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: responseJson,
        statusCode: 200,
        requestOptions: RequestOptions(),
      ),
    );
  }

  void setUpDioFailure404() {
    when(
      mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        data: {'message': 'Not Found.'},
      ),
    );
  }

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
        'should perform a GET request and return WeatherForecastModel when statusCode == 200',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      setUpDioSuccess200(responseJson: jsonMap);

      //act
      final result = await openWeatherMapApiImpl.fetchWeatherForecast(
        lat: tLat,
        lon: tLon,
      );

      //assert
      expect(result, isA<prefix.WeatherForecastModel>());
      expect(result, equals(tWeatherForecast));
      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test(
        'should perform a GET request and throw OpenWeatherMapApiException when statusCode != 200',
        () async {
      //arrange
      setUpDioFailure404();

      //act
      final call = openWeatherMapApiImpl.fetchWeatherForecast;

      //assert
      expect(
        () => call(lat: tLat, lon: tLon),
        throwsA(isA<OpenWeatherMapApiException>()),
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
        'should throw OtherException when the thrown Exception is not OpenWeatherMapApiException',
        () async {
      //arrange
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenThrow(
        DioException(
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
          requestOptions: RequestOptions(),
        ),
      );

      //act
      final call = openWeatherMapApiImpl.fetchWeatherForecast;

      //assert
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
        'should perform a GET request and return LocationCurrentWeatherModel when statusCode == 200',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_current_weather_response.json'),
      ) as MapJson;

      setUpDioSuccess200(responseJson: jsonMap);

      //act
      final result = await openWeatherMapApiImpl.fetchLocationCurrentWeather(
        lat: tLat,
        lon: tLon,
      );

      //assert
      expect(result, isA<LocationCurrentWeatherModel>());
      expect(result, equals(tLocationCurrentWeather));
      verify(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockDio);
    });

    test(
        'should perform a GET request and throw OpenWeatherMapApiException when statusCode != 200',
        () async {
      //arrange
      setUpDioFailure404();

      //act
      final call = openWeatherMapApiImpl.fetchLocationCurrentWeather;

      //assert
      expect(
        () => call(lat: tLat, lon: tLon),
        throwsA(isA<OpenWeatherMapApiException>()),
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
        'should throw OtherException when the thrown Exception is not OpenWeatherMapApiException',
        () async {
      //arrange
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenThrow(
        DioException(
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
          requestOptions: RequestOptions(),
        ),
      );

      //act
      final call = openWeatherMapApiImpl.fetchLocationCurrentWeather;

      //assert
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
}
