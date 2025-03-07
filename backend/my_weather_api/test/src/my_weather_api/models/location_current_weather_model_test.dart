import 'dart:convert';

import 'package:my_weather_api/src/my_weather_api/models/location_current_weather_model.dart';
import 'package:test/test.dart';

import '../../../fixtures/fixture_reader.dart';

typedef MapJson = Map<String, dynamic>;

void main() {
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

  group('LocationCurrentWeatherModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_current_weather_response.json'),
      ) as MapJson;

      //act
      final result = LocationCurrentWeatherModel.fromJson(jsonMap);

      //assert
      expect(result, isA<LocationCurrentWeatherModel>());
      expect(result.current, equals(tLocationCurrentWeather.current));
    });

    test('toJson should return a Json map containing the proper data',
        () async {
      //arrange
      final expectedJson = jsonDecode(
        fixture('open_weather_map_current_weather_response.json'),
      ) as MapJson;

      //act
      final result = tLocationCurrentWeather.toJson();

      //assert
      expect(result, isA<MapJson>());
      expect(result, equals(expectedJson));
      expect(result['timezone_offset'], equals(expectedJson['timezone_offset']));
      expect(result['current'], equals(expectedJson['current']));
    });
  });

  group('Current', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_current_weather_response.json'),
      ) as MapJson;

      final json = jsonMap['current'] as MapJson;

      //act
      final result = Current.fromJson(json);

      //assert
      expect(result, isA<Current>());
      expect(result.dateTimestamp, equals(tCurrent.dateTimestamp));
      expect(result.temp, equals(tCurrent.temp));
      expect(result.weather, equals(tCurrent.weather));
    });

    test('toJson should return a Json map containing the proper data',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_current_weather_response.json'),
      ) as MapJson;

      final expectedJson = jsonMap['current'] as MapJson;

      //act
      final result = tCurrent.toJson();

      //assert
      expect(result, isA<MapJson>());
      expect(result['dt'], equals(expectedJson['dt']));
      expect(result['temp'], equals(expectedJson['temp']));
      expect(result['humidity'], equals(expectedJson['humidity']));
      expect(result['weather'], equals(expectedJson['weather']));
    });
  });

  group('Weather', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_current_weather_response.json'),
      ) as MapJson;

      final json = jsonMap['current']['weather'][0] as MapJson;

      //act
      final result = Weather.fromJson(json);

      //assert
      expect(result, isA<Weather>());
      expect(result.icon, equals(tWeather.icon));
    });

    test('toJson should return a Json map containing the proper data',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_current_weather_response.json'),
      ) as MapJson;

      final expectedJson = jsonMap['current']['weather'][0] as MapJson;

      //act
      final result = tWeather.toJson();

      //assert
      expect(result, equals(expectedJson));
      expect(result['icon'], equals(expectedJson['icon']));
    });
  });
}
