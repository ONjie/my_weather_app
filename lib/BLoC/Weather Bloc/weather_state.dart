import 'package:equatable/equatable.dart';
import 'package:weather_app/Data/Models/favorite_locations_weather_data_model.dart';

import '../../Data/Models/weather_data_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherDataLoadedState extends WeatherState{
 final WeatherData weatherData;
 final List<FavoriteLocationsWeatherData> favoriteLocationsWeatherData;

 const WeatherDataLoadedState({required this.weatherData, required this.favoriteLocationsWeatherData});

  @override
  List<Object> get props => [weatherData, favoriteLocationsWeatherData];

}

class WeatherDataLoadingState extends WeatherState{
  @override
  List<Object> get props => [];
}

class WeatherDataErrorState extends WeatherState{
  final String errorMessage;

  const WeatherDataErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
