import 'package:either_dart/either.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/my_weather_api/data_sources/remote_data_source/open_weather_map_api.dart';
import 'package:my_weather_api/src/my_weather_api/models/location_current_weather_model.dart';
import 'package:my_weather_api/src/my_weather_api/models/weather_forecast_model.dart';

abstract class MyWeatherApiRepository {
  Future<Either<Failure, WeatherForecastModel>> fetchWeatherForecast({
    required double lat,
    required double lon,
  });

  Future<Either<Failure, LocationCurrentWeatherModel>>
      fetchLocationCurrentWeather({
    required double lat,
    required double lon,
  });
}

class MyWeatherApiRepositoryImpl implements MyWeatherApiRepository {
  MyWeatherApiRepositoryImpl({required this.openWeatherMapApi});
  final OpenWeatherMapApi openWeatherMapApi;

  @override
  Future<Either<Failure, WeatherForecastModel>> fetchWeatherForecast({
    required double lat,
    required double lon,
  }) async {
    try {
      final weatherForecast = await openWeatherMapApi.fetchWeatherForecast(
        lat: lat,
        lon: lon,
      );
      return Right(weatherForecast);
    } on OpenWeatherMapApiException catch (e) {
      return Left(
        OpenWeatherMapApiFailure(
          message: e.message!,
        ),
      );
    } on OtherException catch (e) {
      return Left(
        OtherFailure(
          message: e.message!,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, LocationCurrentWeatherModel>>
      fetchLocationCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final locationCurrentWeather =
          await openWeatherMapApi.fetchLocationCurrentWeather(
        lat: lat,
        lon: lon,
      );
      return Right(locationCurrentWeather);
    } on OpenWeatherMapApiException catch (e) {
      return Left(
        OpenWeatherMapApiFailure(
          message: e.message!,
        ),
      );
    } on OtherException catch (e) {
      return Left(
        OtherFailure(
          message: e.message!,
        ),
      );
    }
  }
}
