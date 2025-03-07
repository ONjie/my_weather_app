import 'dart:io';

import 'package:weather_app/core/exceptions/exceptions.dart';
import 'package:weather_app/core/utils/urls/urls.dart';
import 'package:weather_app/features/weather/data/models/weather_forecast_model.dart';
import 'package:dio/dio.dart';

import '../../models/location_current_weather_model.dart';

abstract class WeatherApi {
  Future<WeatherForecastModel> fetchWeatherForecast({
    required double lat,
    required double lon,
  });

  Future<LocationCurrentWeatherModel> fetchLocationCurrentWeather({
    required String locationName,
    required double lat,
    required double lon,
  });
}

class WeatherApiImpl implements WeatherApi {
  final Dio dio;

  WeatherApiImpl({required this.dio});

  @override
  Future<WeatherForecastModel> fetchWeatherForecast({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/$fetchWeatherForecastUrl',
        queryParameters: {
          'lat': lat,
          'lon': lon,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return WeatherForecastModel.fromJson(response.data);
      } else {
        throw ServerException(message: response.data['error'] as String);
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else {
        throw OtherException(message: e.toString());
      }
    }
  }

  @override
  Future<LocationCurrentWeatherModel> fetchLocationCurrentWeather({
    required String locationName,
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/$fetchLocationCurrentWeatherUrl',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'location_name': locationName,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return LocationCurrentWeatherModel.fromJson(response.data);
      } else {

        throw ServerException(message: response.data['error'] as String);
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else {
        throw OtherException(message: e.toString());
      }
    }
  }
}
