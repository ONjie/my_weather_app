import 'dart:convert';
import 'package:my_weather_api/src/weather_api/models/weather_data.dart';
import 'package:test/test.dart';
import '../../../fixtures/fixture_reader.dart';

void main() {
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

  group('WeatherData', () {
    test(
        'WeatherApiData.fromJson should returna valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap =
          json.decode(fixture('weather_data.json')) as Map<String, dynamic>;

      //act
      final result = WeatherData.fromJson(jsonMap);

      //assert
      expect(result.forecast.forecastday[0].date, equals(tForecastday.date));
      expect(
        result.forecast.forecastday[0].dateEpoch,
        equals(tForecastday.dateEpoch),
      );
      expect(
        result.forecast.forecastday[0].day.maxtempC,
        equals(tForecastday.day.maxtempC),
      );
      expect(
        result.forecast.forecastday[0].day.mintempC,
        equals(tForecastday.day.mintempC),
      );
      expect(
        result.forecast.forecastday[0].day.condition.text,
        equals(tForecastday.day.condition.text),
      );
      expect(
        result.forecast.forecastday[0].day.condition.icon,
        equals(tForecastday.day.condition.icon),
      );
      expect(
        result.forecast.forecastday[0].astro.sunrise,
        equals(tForecastday.astro.sunrise),
      );
      expect(
        result.forecast.forecastday[0].astro.sunset,
        equals(tForecastday.astro.sunset),
      );
      expect(
        result.forecast.forecastday[0].astro.moonphase,
        equals(tForecastday.astro.moonphase),
      );
      expect(
        result.forecast.forecastday[0].hour[0].time,
        equals(tForecastday.hour[0].time),
      );
      expect(
        result.forecast.forecastday[0].hour[0].tempC,
        equals(tForecastday.hour[0].tempC),
      );
    });
  });

  group('Condition', () {
    test('Condition.fromJson should returna valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap =
          json.decode(fixture('condition.json')) as Map<String, dynamic>;

      //act
      final result = Condition.fromJson(jsonMap);

      //assert
      expect(result.text, equals(tCondition.text));
      expect(result.icon, equals(tCondition.icon));
    });
  });

  group('Forecast', () {
    test('Forecast.fromJson should returna valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap =
          json.decode(fixture('forecast.json')) as Map<String, dynamic>;

      //act
      final result = Forecast.fromJson(jsonMap);

      //assert
      expect(result.forecastday[0].date, equals(tForecastday.date));
      expect(result.forecastday[0].dateEpoch, equals(tForecastday.dateEpoch));
      expect(
        result.forecastday[0].day.maxtempC,
        equals(tForecastday.day.maxtempC),
      );
      expect(
        result.forecastday[0].day.mintempC,
        equals(tForecastday.day.mintempC),
      );
      expect(
        result.forecastday[0].day.condition.text,
        equals(tForecastday.day.condition.text),
      );
      expect(
        result.forecastday[0].day.condition.icon,
        equals(tForecastday.day.condition.icon),
      );
      expect(
        result.forecastday[0].astro.sunrise,
        equals(tForecastday.astro.sunrise),
      );
      expect(
        result.forecastday[0].astro.sunset,
        equals(tForecastday.astro.sunset),
      );
      expect(
        result.forecastday[0].astro.moonphase,
        equals(tForecastday.astro.moonphase),
      );
      expect(
        result.forecastday[0].hour[0].time,
        equals(tForecastday.hour[0].time),
      );
      expect(
        result.forecastday[0].hour[0].tempC,
        equals(tForecastday.hour[0].tempC),
      );
    });
  });

  group('Forecastday', () {
    test(
        'Forecastday.fromJson should returna valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap =
          json.decode(fixture('forecastday.json')) as Map<String, dynamic>;

      //act
      final result = Forecastday.fromJson(jsonMap);

      //assert
      expect(result.date, equals(tForecastday.date));
      expect(result.dateEpoch, equals(tForecastday.dateEpoch));
      expect(result.day.maxtempC, equals(tForecastday.day.maxtempC));
      expect(result.day.mintempC, equals(tForecastday.day.mintempC));
      expect(
        result.day.condition.text,
        equals(tForecastday.day.condition.text),
      );
      expect(
        result.day.condition.icon,
        equals(tForecastday.day.condition.icon),
      );
      expect(result.astro.sunrise, equals(tForecastday.astro.sunrise));
      expect(result.astro.sunset, equals(tForecastday.astro.sunset));
      expect(result.astro.moonphase, equals(tForecastday.astro.moonphase));
      expect(result.hour[0].time, equals(tForecastday.hour[0].time));
      expect(result.hour[0].tempC, equals(tForecastday.hour[0].tempC));
    });
  });

  group('Day', () {
    test('Day.fromJson should returna valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = json.decode(fixture('day.json')) as Map<String, dynamic>;

      //act
      final result = Day.fromJson(jsonMap);

      //assert
      expect(result.maxtempC, equals(tDay.maxtempC));
      expect(result.mintempC, equals(tDay.mintempC));
      expect(result.condition.text, equals(tDay.condition.text));
      expect(result.condition.icon, equals(tDay.condition.icon));
    });
  });

  group('Astro', () {
    test('Astro.fromJson should returna valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap =
          json.decode(fixture('astro.json')) as Map<String, dynamic>;

      //act
      final result = Astro.fromJson(jsonMap);

      //assert
      expect(result.sunrise, equals(tAstro.sunrise));
      expect(result.sunset, equals(tAstro.sunset));
      expect(result.moonphase, equals(tAstro.moonphase));
    });
  });

  group('Hour', () {
    test('Hour.fromJson should returna valid model when the JSON is valid',
        () async {
      //arrange
      final jsonMap = json.decode(fixture('hour.json')) as Map<String, dynamic>;

      //act
      final result = Hour.fromJson(jsonMap);

      //assert
      expect(result.time, equals(tHour.time));
      expect(result.tempC, equals(tHour.tempC));
    });
  });
}
