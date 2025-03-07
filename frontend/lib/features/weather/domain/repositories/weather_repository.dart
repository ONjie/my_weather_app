import 'package:weather_app/core/failures/failures.dart';
import 'package:either_dart/either.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';

import '../entities/location_current_weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherForecastEntity>> fetchWeatherForecast();

  Future<Either<Failure, List<LocationCurrentWeatherEntity>>>
      fetchLocationCurrentWeather();
}
