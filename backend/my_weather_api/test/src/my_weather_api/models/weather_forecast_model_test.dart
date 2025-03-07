import 'dart:convert';

import 'package:my_weather_api/src/my_weather_api/models/weather_forecast_model.dart';
import 'package:test/test.dart';

import '../../../fixtures/fixture_reader.dart';

typedef MapJson = Map<String, dynamic>;

void main() {
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

  group('WeatherForecastModel', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      //act
      final result = WeatherForecastModel.fromJson(jsonMap);

      //assert
      expect(result, isA<WeatherForecastModel>());
      expect(result.hourly, equals(tWeatherForecast.hourly));
      expect(result.daily, equals(tWeatherForecast.daily));
    });

    test('toJson should return a Json map containing the proper data',
        () async {
      //arrange
      final expectedJson = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      //act
      final result = tWeatherForecast.toJson();

      //assert
      expect(result, equals(expectedJson));
      expect(result['hourly'], equals(expectedJson['hourly']));
      expect(result['daily'], equals(expectedJson['daily']));
    });
  });

  group('Hourly', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      final json = jsonMap['hourly'][0] as MapJson;

      //act
      final result = Hourly.fromJson(json);

      //assert
      expect(result, isA<Hourly>());
      expect(result.dateTimestamp, equals(tHourly.dateTimestamp));
      expect(result.temp, equals(tHourly.temp));
      expect(result.humidity, equals(tHourly.humidity));
      expect(result.weather, equals(tHourly.weather));
    });

    test('toJson should return a Json map containing the proper data',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      final expectedJson = jsonMap['hourly'][0] as MapJson;

      //act
      final result = tHourly.toJson();

      //assert
      expect(result, equals(expectedJson));
      expect(result['dt'], equals(expectedJson['dt']));
      expect(result['humidity'], equals(expectedJson['humidity']));
      expect(result['temp'], equals(expectedJson['temp']));
      expect(result['weather'], equals(expectedJson['weather']));
    });
  });

  group('Daily', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      final json = jsonMap['daily'][0] as MapJson;

      //act
      final result = Daily.fromJson(json);

      //assert
      expect(result, isA<Daily>());
      expect(result.dateTimestamp, equals(tDaily.dateTimestamp));
      expect(result.sunriseTimestamp, equals(tDaily.sunriseTimestamp));
      expect(result.sunsetTimestamp, equals(tDaily.sunsetTimestamp));
      expect(result.temp, equals(tDaily.temp));
      expect(result.weather, equals(tDaily.weather));
    });

    test('toJson should return a Json map containing the proper data',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      final expectedJson = jsonMap['daily'][0] as MapJson;

      //act
      final result = tDaily.toJson();

      //assert
      expect(result, equals(expectedJson));
      expect(result['dt'], equals(expectedJson['dt']));
      expect(result['sunrise'], equals(expectedJson['sunrise']));
      expect(result['sunset'], equals(expectedJson['sunset']));
      expect(result['temp'], equals(expectedJson['temp']));
      expect(result['weather'], equals(expectedJson['weather']));
    });
  });

  group('Temp', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      final json = jsonMap['daily'][0]['temp'] as MapJson;

      //act
      final result = Temp.fromJson(json);

      //assert
      expect(result, isA<Temp>());
      expect(result.maxTemp, equals(tTemp.maxTemp));
      expect(result.minTemp, equals(tTemp.minTemp));
    });

    test('toJson should return a Json map containing the proper data',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      final expectedJson = jsonMap['daily'][0]['temp'] as MapJson;

      //act
      final result = tTemp.toJson();

      //assert
      expect(result, equals(expectedJson));
      expect(result['max'], equals(expectedJson['max']));
      expect(result['min'], equals(expectedJson['min']));
    });
  });

  group('Weather', () {
    test('fromJson should return a valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      final json = jsonMap['daily'][0]['weather'][0] as MapJson;

      //act
      final result = Weather.fromJson(json);

      //assert
      expect(result, isA<Weather>());
      expect(result.description, equals(tWeather.description));
      expect(result.icon, equals(tWeather.icon));
    });

    test('toJson should return a Json map containing the proper data',
        () async {
      //arrange
      final jsonMap = jsonDecode(
        fixture('open_weather_map_weather_forecast_response.json'),
      ) as MapJson;

      final expectedJson = jsonMap['daily'][0]['weather'][0] as MapJson;

      //act
      final result = tWeather.toJson();

      //assert
      expect(result, equals(expectedJson));
      expect(result['description'], equals(expectedJson['description']));
      expect(result['icon'], equals(expectedJson['icon']));
    });
  });
}
