import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/weather_forecast_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

typedef MapJson = Map<String, dynamic>;

void main() {
  const tTemp = TempModel(
    maxTemp: 23.06,
    minTemp: 19.15,
  );

  const tWeather = WeatherModel(
    description: 'clear sky',
    icon: '01n',
  );

  const tDaily = DailyModel(
    dateTimestamp: 1739883600,
    sunriseTimestamp: 1739863686,
    sunsetTimestamp: 1739905959,
    temp: tTemp,
    weather: [tWeather],
  );

  const tHourly = HourlyModel(
    dateTimestamp: 1739919600,
    temp: 21.95,
    weather: [tWeather],
    humidity: 66,
  );

  const tWeatherForecast = WeatherForecastModel(
    hourly: [tHourly, tHourly],
    daily: [tDaily, tDaily],
  );

  group('WeatherForecastModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('my_weather_api_weather_forecast_response.json'),
      ) as MapJson;

      //act
      final result = WeatherForecastModel.fromJson(jsonMap);

      //assert
      expect(result, isA<WeatherForecastModel>());
      expect(result.hourly, equals(tWeatherForecast.hourly));
      expect(result.daily, equals(tWeatherForecast.daily));
    });

    test(
        'toWeatherForecastEntity should return a WeatherForecastEntity containing the proper data',
        () async {
      //arrangr&act
      final result = tWeatherForecast.toWeatherForecastEntity();

      //assert
      expect(result, isA<WeatherForecastEntity>());
      expect(
          result.hourly,
          equals(
              tWeatherForecast.hourly.map((e) => e.toHourlyEntity()).toList()));
      expect(
          result.daily,
          equals(
              tWeatherForecast.daily.map((e) => e.toDailyEntity()).toList()));
    });
  });

  group('HourlyModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('my_weather_api_weather_forecast_response.json'),
      ) as MapJson;

      final json = jsonMap['hourly'][0] as MapJson;

      //act
      final result = HourlyModel.fromJson(json);

      //assert
      expect(result, isA<HourlyModel>());
      expect(result.dateTimestamp, equals(tHourly.dateTimestamp));
      expect(result.temp, equals(tHourly.temp));
      expect(result.humidity, equals(tHourly.humidity));
      expect(result.weather, equals(tHourly.weather));
    });

    test(
        'toHourlyEntity should return a toHourlyEntity containing the proper data',
        () async {
      //arrange&act
      final result = tHourly.toHourlyEntity();

      //assert
      expect(result, isA<HourlyEntity>());
      expect(result.dateTimestamp, equals(tHourly.dateTimestamp));
      expect(result.temp, equals(tHourly.temp));
      expect(result.humidity, equals(tHourly.humidity));
      expect(result.weather,
          equals(tHourly.weather.map((e) => e.toWeatherEntity()).toList()));
    });
  });

  group('DailyModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('my_weather_api_weather_forecast_response.json'),
      ) as MapJson;

      final json = jsonMap['daily'][0] as MapJson;

      //act
      final result = DailyModel.fromJson(json);

      //assert
      expect(result, isA<DailyModel>());
      expect(result.dateTimestamp, equals(tDaily.dateTimestamp));
      expect(result.sunriseTimestamp, equals(tDaily.sunriseTimestamp));
      expect(result.sunsetTimestamp, equals(tDaily.sunsetTimestamp));
      expect(result.temp, equals(tDaily.temp));
      expect(result.weather, equals(tDaily.weather));
    });

    test('toDailyEntity should return a DailyEntity containing the proper data',
        () async {
      //arrange&act
      final result = tDaily.toDailyEntity();

      //assert
      expect(result, isA<DailyEntity>());
      expect(result.dateTimestamp, equals(tDaily.dateTimestamp));
      expect(result.sunriseTimestamp, equals(tDaily.sunriseTimestamp));
      expect(result.sunsetTimestamp, equals(tDaily.sunsetTimestamp));
      expect(result.temp, equals(tDaily.temp.toTempEntity()));
      expect(result.weather,
          equals(tDaily.weather.map((e) => e.toWeatherEntity()).toList()));
    });
  });

  group('TempModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('my_weather_api_weather_forecast_response.json'),
      ) as MapJson;

      final json = jsonMap['daily'][0]['temp'] as MapJson;

      //act
      final result = TempModel.fromJson(json);

      //assert
      expect(result, isA<TempModel>());
      expect(result.maxTemp, equals(tTemp.maxTemp));
      expect(result.minTemp, equals(tTemp.minTemp));
    });

    test('toTempEntity should return a TempEntity containing the proper data',
        () async {
      //arrange&act
      final result = tTemp.toTempEntity();

      //assert
      expect(result, isA<TempEntity>());
      expect(result.maxTemp, equals(tTemp.maxTemp));
      expect(result.minTemp, equals(tTemp.minTemp));
    });
  });

  group('WeatherModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('my_weather_api_weather_forecast_response.json'),
      ) as MapJson;

      final json = jsonMap['daily'][0]['weather'][0] as MapJson;

      //act
      final result = WeatherModel.fromJson(json);

      //assert
      expect(result, isA<WeatherModel>());
      expect(result.description, equals(tWeather.description));
      expect(result.icon, equals(tWeather.icon));
    });

    test('toWeatherEntity should return a WeatherEntity containing the proper data',
        () async {
      //arrange&act
      final result = tWeather.toWeatherEntity();

      //assert
      expect(result, isA<WeatherEntity>());
      expect(result.description, equals(tWeather.description));
      expect(result.icon, equals(tWeather.icon));
    
    });
  });
}
