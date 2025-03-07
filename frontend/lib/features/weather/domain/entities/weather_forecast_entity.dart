import 'package:equatable/equatable.dart';

class WeatherForecastEntity extends Equatable {
  const WeatherForecastEntity({
    required this.hourly,
    required this.daily,
  });

 final List<HourlyEntity> hourly;
  final List<DailyEntity> daily;

  @override
  List<Object?> get props => [hourly, daily];
}

class HourlyEntity extends Equatable {
  const HourlyEntity({
    required this.dateTimestamp,
    required this.temp,
    required this.weather,
    required this.humidity,
  });

  final int dateTimestamp;
  final double temp;
  final List<WeatherEntity> weather;
  final int humidity;

  @override
  List<Object?> get props => [
        dateTimestamp,
        temp,
        weather,
        humidity,
      ];
}

class DailyEntity extends Equatable {
  const DailyEntity({
    required this.dateTimestamp,
    required this.sunriseTimestamp,
    required this.sunsetTimestamp,
    required this.temp,
    required this.weather,
  });

  final int dateTimestamp;
  final int sunriseTimestamp;
  final int sunsetTimestamp;
  final TempEntity temp;
  final List<WeatherEntity> weather;

  @override
  List<Object?> get props => [
        dateTimestamp,
        sunriseTimestamp,
        sunsetTimestamp,
        temp,
        weather,
      ];
}

class TempEntity extends Equatable {
  const TempEntity({
    required this.maxTemp,
    required this.minTemp,
  });

  final double maxTemp;
  final double minTemp;

  @override
  List<Object?> get props => [maxTemp, minTemp];
}

class WeatherEntity extends Equatable {
  const WeatherEntity({
    required this.description,
    required this.icon,
  });

  final String description;
  final String icon;

  @override
  List<Object?> get props => [description, icon];
}
