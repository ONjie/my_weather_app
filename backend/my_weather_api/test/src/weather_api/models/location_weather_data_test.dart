import 'dart:convert';

import 'package:my_weather_api/src/weather_api/models/location_weather_data.dart';
import 'package:test/test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tLocationWeatherData = LocationWeatherData(
    locationName: 'Banjul',
    localtimeEpoch: 1737504398,
    localtime: '2025-01-22 00:06',
    tempC: 21.3,
    icon: '//cdn.weatherapi.com/weather/64x64/night/113.png',
    country: 'Gambia',
  );

  group('LocationWatherData', () {
    test(
        'LocationWatherData.fromJson should return a valid model when the JSON is valid',
        () async {
      // arrange
      final jsonMap = json.decode(fixture('location_weather_data.json'))
          as Map<String, dynamic>;
      // act
      final result = LocationWeatherData.fromJson(jsonMap);
      // assert
      expect(result.locationName, tLocationWeatherData.locationName);
      expect(result.localtimeEpoch, tLocationWeatherData.localtimeEpoch);
      expect(result.localtime, tLocationWeatherData.localtime);
      expect(result.tempC, tLocationWeatherData.tempC);
      expect(result.icon, tLocationWeatherData.icon);
      expect(result.country, tLocationWeatherData.country);
    });
  });
}
