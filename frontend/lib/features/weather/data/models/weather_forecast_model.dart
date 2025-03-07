import 'package:equatable/equatable.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';

typedef MapJson = Map<String, dynamic>;

class WeatherForecastModel extends Equatable {
  const WeatherForecastModel({
    required this.hourly,
    required this.daily,
  });

  factory WeatherForecastModel.fromJson(MapJson json) {
    return WeatherForecastModel(
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => HourlyModel.fromJson(e as MapJson))
          .toList(),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => DailyModel.fromJson(e as MapJson))
          .toList(),
    );
  }

  WeatherForecastEntity toWeatherForecastEntity() {
    return WeatherForecastEntity(
      hourly: hourly.map((e) => e.toHourlyEntity()).toList(),
      daily: daily.map((e) => e.toDailyEntity()).toList(),
    );
  }

  final List<HourlyModel> hourly;
  final List<DailyModel> daily;

  @override
  List<Object?> get props => [hourly, daily];
}

class HourlyModel extends Equatable {
  const HourlyModel({
    required this.dateTimestamp,
    required this.temp,
    required this.weather,
    required this.humidity,
  });

  factory HourlyModel.fromJson(MapJson json) {
    return HourlyModel(
      dateTimestamp: json['dt'] as int,
      temp: (json['temp'] as num).toDouble(),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => WeatherModel.fromJson(e as MapJson))
          .toList(),
      humidity: json['humidity'] as int,
    );
  }
  
  HourlyEntity toHourlyEntity() {
    return HourlyEntity(
      dateTimestamp: dateTimestamp,
      temp: temp,
      weather: weather.map((e) => e.toWeatherEntity()).toList(),
      humidity: humidity,
    );
  }

  final int dateTimestamp;
  final double temp;
  final List<WeatherModel> weather;
  final int humidity;

  @override
  List<Object?> get props => [
        dateTimestamp,
        temp,
        weather,
        humidity,
      ];
}

class DailyModel extends Equatable {
  const DailyModel({
    required this.dateTimestamp,
    required this.sunriseTimestamp,
    required this.sunsetTimestamp,
    required this.temp,
    required this.weather,
  });

  factory DailyModel.fromJson(MapJson json) {
    return DailyModel(
      dateTimestamp: json['dt'] as int,
      sunriseTimestamp: json['sunrise'] as int,
      sunsetTimestamp: json['sunset'] as int,
      temp: TempModel.fromJson(json['temp'] as MapJson),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => WeatherModel.fromJson(e as MapJson))
          .toList(),
    );
  }

  DailyEntity toDailyEntity() {
    return DailyEntity(
      dateTimestamp: dateTimestamp,
      sunriseTimestamp: sunriseTimestamp,
      sunsetTimestamp: sunsetTimestamp,
      temp: temp.toTempEntity(),
      weather: weather.map((e) => e.toWeatherEntity()).toList(),
    );
  }

  final int dateTimestamp;
  final int sunriseTimestamp;
  final int sunsetTimestamp;
  final TempModel temp;
  final List<WeatherModel> weather;

  @override
  List<Object?> get props => [
        dateTimestamp,
        sunriseTimestamp,
        sunsetTimestamp,
        temp,
        weather,
      ];
}

class TempModel extends Equatable {
  const TempModel({
    required this.maxTemp,
    required this.minTemp,
  });

  factory TempModel.fromJson(MapJson json) {
    return TempModel(
      maxTemp: (json['max'] as num).toDouble(),
      minTemp: (json['min'] as num).toDouble(),
    );
  }

  TempEntity toTempEntity() {
    return TempEntity(
      maxTemp: maxTemp,
      minTemp: minTemp,
    );
  }

  final double maxTemp;
  final double minTemp;

  @override
  List<Object?> get props => [maxTemp, minTemp];
}

class WeatherModel extends Equatable {
  const WeatherModel({
    required this.description,
    required this.icon,
  });

  factory WeatherModel.fromJson(MapJson json) {
    return WeatherModel(
      description: json['description'] as String,
      icon: json['icon'] as String,
    );
  }

  WeatherEntity toWeatherEntity() {
    return WeatherEntity(
      description: description,
      icon: icon,
    );
  }

  final String description;
  final String icon;

  @override
  List<Object?> get props => [description, icon];
}
