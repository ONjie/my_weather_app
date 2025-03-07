import 'package:equatable/equatable.dart';
import 'package:weather_app/features/weather/domain/entities/location_current_weather_entity.dart';

typedef MapJson = Map<String, dynamic>;

class LocationCurrentWeatherModel extends Equatable {
  const LocationCurrentWeatherModel({
    required this.current,
    required this.locationName,
    required this.timezoneOffset,
  });

  factory LocationCurrentWeatherModel.fromJson(MapJson json) {
    return LocationCurrentWeatherModel(
      timezoneOffset: json['current_weather']['timezone_offset'] as int,
      current:
          CurrentModel.fromJson(json['current_weather']['current'] as MapJson),
      locationName: json['location_name'] as String,
    );
  }

  LocationCurrentWeatherEntity toLocationCurrentWeatherEntity() {
    return LocationCurrentWeatherEntity(
      current: current.toCurrentEntity(),
      locationName: locationName,
      timezoneOffset: timezoneOffset,
    );
  }

  final CurrentModel current;
  final String locationName;
  final int timezoneOffset;

  @override
  List<Object?> get props => [current];
}

class CurrentModel extends Equatable {
  const CurrentModel({
    required this.dateTimestamp,
    required this.temp,
    required this.weather,
  });

  factory CurrentModel.fromJson(MapJson json) {
    return CurrentModel(
      dateTimestamp: json['dt'] as int,
      temp: (json['temp'] as num).toDouble(),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => WeatherModel.fromJson(e as MapJson))
          .toList(),
    );
  }

  CurrentEntity toCurrentEntity() {
    return CurrentEntity(
      dateTimestamp: dateTimestamp,
      temp: temp,
      weather: weather.map((e) => e.toWeatherEntity()).toList(),
    );
  }

  final int dateTimestamp;
  final double temp;
  final List<WeatherModel> weather;

  @override
  List<Object?> get props => [
        dateTimestamp,
        temp,
        weather,
      ];
}

class WeatherModel extends Equatable {
  const WeatherModel({
    required this.icon,
  });

  factory WeatherModel.fromJson(MapJson json) {
    return WeatherModel(
      icon: json['icon'] as String,
    );
  }

  WeatherEntity toWeatherEntity() {
    return WeatherEntity(icon: icon);
  }

  final String icon;

  @override
  List<Object?> get props => [icon];
}
