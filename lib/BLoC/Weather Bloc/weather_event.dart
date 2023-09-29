import 'package:equatable/equatable.dart';


abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class OnGetWeatherDataEvent extends WeatherEvent{

  @override
  List<Object> get props => [];
}

class OnGetFavoriteLocationsWeatherDataEvent extends WeatherEvent{

  @override
  List<Object> get props => [];
}
