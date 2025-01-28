// ignore_for_file: camel_case_types
import 'package:either_dart/either.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/weather_api/datasources/remote_data_sources/weather_api.dart';
import 'package:my_weather_api/src/weather_api/models/location_weather_data.dart';
import 'package:my_weather_api/src/weather_api/models/weather_data.dart';

abstract class WeatherApiRepository {
  Future<Either<Failure, LocationWeatherData>> getLocationWeatherData({
    required String locationName,
  });

  Future<Either<Failure, WeatherData>> getWeatherData({
    required double lat,
    required double long,
  });
}

class WeatherApiRepositoryImpl implements WeatherApiRepository {
  WeatherApiRepositoryImpl({required this.weatherApi});
  final WeatherApi weatherApi;

  @override
  Future<Either<Failure, LocationWeatherData>> getLocationWeatherData({
    required String locationName,
  }) async {
    try {
      final locationWeatherData =
          await weatherApi.getLocationWeatherData(locationName: locationName);
      return Right(locationWeatherData);
    } on WeatherApiException catch (e) {
      return Left(WeatherApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, WeatherData>> getWeatherData({
    required double lat,
    required double long,
  }) async {
    try {
      final weatherData = await weatherApi.getWeatherData(lat: lat, long: long);
      return Right(weatherData);
    } on WeatherApiException catch (e) {
      return Left(WeatherApiFailure(message: e.message!));
    }
  }
}
