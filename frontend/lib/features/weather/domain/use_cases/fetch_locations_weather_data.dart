import 'package:either_dart/either.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

import '../entities/location_current_weather_entity.dart';

class FetchLocationsCurrentWeather {
  FetchLocationsCurrentWeather({required this.weatherRepository});

  final WeatherRepository weatherRepository;

  Future<Either<Failure, List<LocationCurrentWeatherEntity>>> execute() async =>
      await weatherRepository.fetchLocationCurrentWeather();
}
