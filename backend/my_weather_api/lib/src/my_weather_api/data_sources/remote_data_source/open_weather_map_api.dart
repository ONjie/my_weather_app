import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/core/utils/open_weather_map_api_urls.dart';
import 'package:my_weather_api/env/env.dart';
import 'package:my_weather_api/src/my_weather_api/models/location_current_weather_model.dart';
import 'package:my_weather_api/src/my_weather_api/models/weather_forecast_model.dart';

typedef MapJson = Map<String, dynamic>;

abstract class OpenWeatherMapApi {
  Future<WeatherForecastModel> fetchWeatherForecast({
    required double lat,
    required double lon,
  });

  Future<LocationCurrentWeatherModel> fetchLocationCurrentWeather({
    required double lat,
    required double lon,
  });
}

class OpenWeatherMapApiImpl implements OpenWeatherMapApi {
  OpenWeatherMapApiImpl({required this.dio});
  final Dio dio;

  @override
  Future<WeatherForecastModel> fetchWeatherForecast({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await dio.get(
        openWeatherMapApiBaseUrl,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'exclude': 'current, minutely, alerts',
          'appid': Env.openWeatherMapApiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return WeatherForecastModel.fromJson(response.data as MapJson);
      } else {
        throw OpenWeatherMapApiException(
          message: response.data['message'] as String,
        );
      }
    } catch (e) {
      if (e is OpenWeatherMapApiException) {
        rethrow;
      } else {
        throw OtherException(message: e.toString());
      }
    }
  }

  @override
  Future<LocationCurrentWeatherModel> fetchLocationCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await dio.get(
        openWeatherMapApiBaseUrl,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'exclude': 'hourly, minutely, alerts',
          'appid': Env.openWeatherMapApiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return LocationCurrentWeatherModel.fromJson(response.data as MapJson);
      } else {
        throw OpenWeatherMapApiException(
          message: response.data['message'] as String,
        );
      }
    } catch (e) {
      if (e is OpenWeatherMapApiException) {
        rethrow;
      } else {
        throw OtherException(message: e.toString());
      }
    }
  }
}
