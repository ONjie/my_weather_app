import 'package:equatable/equatable.dart';

class LocationCurrentWeatherEntity extends Equatable {
  const LocationCurrentWeatherEntity({
    required this.current,
    required this.locationName,
    required this.timezoneOffset,
  });

  final CurrentEntity current;
  final String locationName;
  final int timezoneOffset;

  @override
  List<Object?> get props => [current, locationName, timezoneOffset];
}

class CurrentEntity extends Equatable {
  const CurrentEntity({
    required this.dateTimestamp,
    required this.temp,
    required this.weather,
  });

  final int dateTimestamp;
  final double temp;
  final List<WeatherEntity> weather;

  @override
  List<Object?> get props => [
        dateTimestamp,
        temp,
        weather,
      ];
}

class WeatherEntity extends Equatable {
  const WeatherEntity({
    required this.icon,
  });

  final String icon;

  @override
  List<Object?> get props => [icon];
}
