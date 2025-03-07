import 'package:equatable/equatable.dart';

typedef MapJson = Map<String, dynamic>;

class WeatherForecastModel extends Equatable {
  const WeatherForecastModel({
    required this.hourly,
    required this.daily,
  });

  factory WeatherForecastModel.fromJson(MapJson json) {
    return WeatherForecastModel(
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => Hourly.fromJson(e as MapJson))
          .toList(),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => Daily.fromJson(e as MapJson))
          .toList(),
    );
  }

  MapJson toJson() {
    return {
      'hourly': hourly.map((e) => e.toJson()).toList(),
      'daily': daily.map((e) => e.toJson()).toList(),
    };
  }

  final List<Hourly> hourly;
  final List<Daily> daily;

  @override
  List<Object?> get props => [hourly, daily];
}

class Hourly extends Equatable {
  const Hourly({
    required this.dateTimestamp,
    required this.temp,
    required this.weather,
    required this.humidity,
  });

  factory Hourly.fromJson(MapJson json) {
    return Hourly(
      dateTimestamp: json['dt'] as int,
      temp: (json['temp'] as num).toDouble(),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as MapJson))
          .toList(),
      humidity: json['humidity'] as int,
    );
  }
  MapJson toJson() {
    return {
      'dt': dateTimestamp,
      'temp': temp,
      'weather': weather.map((e) => e.toJson()).toList(),
      'humidity': humidity,
    };
  }

  final int dateTimestamp;
  final double temp;
  final List<Weather> weather;
  final int humidity;

  @override
  List<Object?> get props => [
        dateTimestamp,
        temp,
        weather,
        humidity,
      ];
}

class Daily extends Equatable {
  const Daily({
    required this.dateTimestamp,
    required this.sunriseTimestamp,
    required this.sunsetTimestamp,
    required this.temp,
    required this.weather,
  });

  factory Daily.fromJson(MapJson json) {
    return Daily(
      dateTimestamp: json['dt'] as int,
      sunriseTimestamp: json['sunrise'] as int,
      sunsetTimestamp: json['sunset'] as int,
      temp: Temp.fromJson(json['temp'] as MapJson),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as MapJson))
          .toList(),
    );
  }

  MapJson toJson() {
    return {
      'dt': dateTimestamp,
      'sunrise': sunriseTimestamp,
      'sunset': sunsetTimestamp,
      'temp': temp.toJson(),
      'weather': weather.map((e) => e.toJson()).toList(),
    };
  }

  final int dateTimestamp;
  final int sunriseTimestamp;
  final int sunsetTimestamp;
  final Temp temp;
  final List<Weather> weather;

  @override
  List<Object?> get props => [
        dateTimestamp,
        sunriseTimestamp,
        sunsetTimestamp,
        temp,
        weather,
      ];
}

class Temp extends Equatable {
  const Temp({
    required this.maxTemp,
    required this.minTemp,
  });

  factory Temp.fromJson(MapJson json) {
    return Temp(
      maxTemp: (json['max'] as num).toDouble(),
      minTemp: (json['min'] as num).toDouble(),
    );
  }

  MapJson toJson() {
    return {
      'max': maxTemp,
      'min': minTemp,
    };
  }

  final double maxTemp;
  final double minTemp;

  @override
  List<Object?> get props => [maxTemp, minTemp];
}

class Weather extends Equatable {
  const Weather({
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(MapJson json) {
    return Weather(
      description: json['description'] as String,
      icon: json['icon'] as String,
    );
  }

  MapJson toJson() {
    return {
      'description': description,
      'icon': icon,
    };
  }

  final String description;
  final String icon;

  @override
  List<Object?> get props => [description, icon];
}
