part of 'weather_bloc.dart';

enum WeatherStatus {
  intial,
  loading,
  weatherForecastLoaded,
  fetchWeatherForecastError,
  locationsCurrentWeatherLoading,
  locationsCurrentWeatherLoaded,
  fetchLocationsCurrentWeatherError,
}

class WeatherState extends Equatable {
  const WeatherState({
    required this.weatherStatus,
    this.weatherForecast,
    this.locationsCurrentWeather,
    this.errorMessage,
  });

  final WeatherStatus weatherStatus;
  final WeatherForecastEntity? weatherForecast;
  final List<LocationCurrentWeatherEntity>? locationsCurrentWeather;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        weatherStatus,
        weatherForecast,
        locationsCurrentWeather,
        errorMessage,
      ];
}
