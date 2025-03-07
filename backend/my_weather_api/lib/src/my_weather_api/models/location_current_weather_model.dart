import 'package:equatable/equatable.dart';

typedef MapJson = Map<String, dynamic>;

class LocationCurrentWeatherModel extends Equatable {
  const LocationCurrentWeatherModel({
    required this.current,
    required this.timezoneOffset,
  });

  factory LocationCurrentWeatherModel.fromJson(MapJson json) {
    return LocationCurrentWeatherModel(
      timezoneOffset: (json['timezone_offset'] as num).toInt(),
      current: Current.fromJson(json['current'] as MapJson),
    );
  }

  final Current current;
  final int timezoneOffset;

  MapJson toJson() {
    return {
      'timezone_offset': timezoneOffset,
      'current': current.toJson(),
    };
  }

  @override
  List<Object?> get props => [current];
}

class Current extends Equatable {
  const Current({
    required this.dateTimestamp,
    required this.temp,
    required this.weather,
  });

  factory Current.fromJson(MapJson json) {
    return Current(
      dateTimestamp: json['dt'] as int,
      temp: (json['temp'] as num).toDouble(),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as MapJson))
          .toList(),
    );
  }

  MapJson toJson() {
    return {
      'dt': dateTimestamp,
      'temp': temp,
      'weather': weather.map((e) => e.toJson()).toList(),
    };
  }

  final int dateTimestamp;
  final double temp;
  final List<Weather> weather;

  @override
  List<Object?> get props => [
        dateTimestamp,
        temp,
        weather,
      ];
}

class Weather extends Equatable {
  const Weather({
    required this.icon,
  });

  factory Weather.fromJson(MapJson json) {
    return Weather(
      icon: json['icon'] as String,
    );
  }

  MapJson toJson() {
    return {
      'icon': icon,
    };
  }

  final String icon;

  @override
  List<Object?> get props => [icon];
}
