// ignore_for_file: lines_longer_than_80_chars, inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/core/utils/weather_api_urls.dart';
import 'package:my_weather_api/env/env.dart';
import 'package:my_weather_api/src/weather_api/models/location_weather_data.dart';
import 'package:my_weather_api/src/weather_api/models/weather_data.dart';

abstract class WeatherApi {
  Future<WeatherData> getWeatherData({
    required double lat,
    required double long,
  });

  Future<LocationWeatherData> getLocationWeatherData({
    required String locationName,
  });
}

class WeatherApiImpl implements WeatherApi {
  WeatherApiImpl({required this.dio});

  late Dio dio;

  @override
  Future<LocationWeatherData> getLocationWeatherData({
    required String locationName,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl$currentWeather?key=${Env.apiKey}&q=$locationName&days=7',
      );

      final results =
          LocationWeatherData.fromJson(response.data as Map<String, dynamic>);

      return results;
    } catch (e) {
      throw WeatherApiException(message: e.toString());
    }
  }

  @override
  Future<WeatherData> getWeatherData({
    required double lat,
    required double long,
  }) async {
    try {
      final response = await dio
          .get('$baseUrl$forecast?key=${Env.apiKey}&q=$lat,$long&days=7');

      return WeatherData.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw WeatherApiException(message: e.toString());
    }
  }
}
