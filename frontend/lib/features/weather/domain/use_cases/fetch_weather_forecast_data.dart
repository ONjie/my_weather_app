import 'package:either_dart/either.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class FetchWeatherForecast {
  final WeatherRepository weatherRepository;

  FetchWeatherForecast({required this.weatherRepository});

  Future<Either<Failure, WeatherForecastEntity>> execute() async =>
      await weatherRepository.fetchWeatherForecast();
}
