import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/location_current_weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/location_current_weather_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

typedef MapJson = Map<String, dynamic>;

void main() {

  const locationName = 'Banjul';
  
  const tWeather = WeatherModel(
    icon: '01n',
  );

  const tCurrent = CurrentModel(
    dateTimestamp: 1739934864,
    temp: 21.15,
    weather: [tWeather],
  );

  const tLocationCurrentWeather = LocationCurrentWeatherModel(
    current: tCurrent,
    locationName: locationName,
    timezoneOffset: 0,

  );

  group('LocationCurrentWeatherModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('my_weather_api_current_weather_response.json'),
      ) as MapJson;

      //act
      final result = LocationCurrentWeatherModel.fromJson(jsonMap);

      //assert
      expect(result, isA<LocationCurrentWeatherModel>());
      expect(result.current, equals(tLocationCurrentWeather.current));
    });

    test('toLocationCurrentWeatherEntity should return a LocationCurrentWeatherEntity containing the proper data',
        () async {
      //arrange&act
      final result = tLocationCurrentWeather.toLocationCurrentWeatherEntity();

      //assert
      expect(result, isA<LocationCurrentWeatherEntity>());
      expect(result.current, equals(tLocationCurrentWeather.current.toCurrentEntity()));
      
    });
  });

  group('CurrentModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('my_weather_api_current_weather_response.json'),
      ) as MapJson;

      final json = jsonMap['current_weather']['current'] as MapJson;

      //act
      final result = CurrentModel.fromJson(json);

      //assert
      expect(result, isA<CurrentModel>());
      expect(result.dateTimestamp, equals(tCurrent.dateTimestamp));
      expect(result.temp, equals(tCurrent.temp));
      expect(result.weather, equals(tCurrent.weather));
    });

    test('toCurrentEntity should return a CurrentEntity containing the proper data',
        () async {
      //arrange&act
      final result = tCurrent.toCurrentEntity();

      //assert
      expect(result, isA<CurrentEntity>());
      expect(result.dateTimestamp, equals(tCurrent.dateTimestamp));
      expect(result.temp, equals(tCurrent.temp));
      expect(result.weather, equals(tCurrent.weather.map((e) => e.toWeatherEntity()).toList()));
      
    });
  });

  group('WeatherModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('my_weather_api_current_weather_response.json'),
      ) as MapJson;

      final json = jsonMap['current_weather']['current']['weather'][0] as MapJson;

      //act
      final result = WeatherModel.fromJson(json);

      //assert
      expect(result, isA<WeatherModel>());
      expect(result.icon, equals(tWeather.icon));
    });

    test('toWeatherEntity should return a WeatherEntity containing the proper data',
        () async {
      //arrange&act
      final result = tWeather.toWeatherEntity();

      //assert
      expect(result, isA<WeatherEntity>());
      expect(result.icon, equals(tWeather.icon));
      
    });
  });
}
