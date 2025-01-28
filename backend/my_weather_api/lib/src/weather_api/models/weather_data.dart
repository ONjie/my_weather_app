typedef MapJson = Map<String, dynamic>;

class WeatherData {
  WeatherData({required this.forecast});

  WeatherData.fromJson(MapJson json) {
    forecast = Forecast.fromJson(json['forecast'] as MapJson);
  }

  late final Forecast forecast;
}

class Condition {
  Condition({required this.text, required this.icon});

  Condition.fromJson(MapJson json) {
    text = json['text'] as String;
    icon = json['icon'] as String;
  }

  late final String text;
  late final String icon;
}

class Forecast {
  Forecast({required this.forecastday});

  Forecast.fromJson(MapJson json) {
    forecastday = (json['forecastday'] as List<dynamic>)
        .map((e) => Forecastday.fromJson(e as MapJson))
        .toList();
  }

  late final List<Forecastday> forecastday;
}

class Forecastday {
  Forecastday({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.astro,
    required this.hour,
  });

  Forecastday.fromJson(MapJson json) {
    date = json['date'] as String;
    dateEpoch = json['date_epoch'] as int;
    day = Day.fromJson(json['day'] as MapJson);
    astro = Astro.fromJson(json['astro'] as MapJson);
    hour = (json['hour'] as List<dynamic>)
        .map((e) => Hour.fromJson(e as MapJson))
        .toList();
  }

  late final String date;
  late final int dateEpoch;
  late final Day day;
  late final Astro astro;
  late final List<Hour> hour;
}

class Day {
  Day({
    required this.maxtempC,
    required this.mintempC,
    required this.condition,
  });

  Day.fromJson(MapJson json) {
    maxtempC = json['maxtemp_c'] as double;
    mintempC = json['mintemp_c'] as double;
    condition = Condition.fromJson(json['condition'] as MapJson);
  }

  late final double maxtempC;
  late final double mintempC;
  late final Condition condition;
}

class Astro {
  Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonphase,
  });

  Astro.fromJson(MapJson json) {
    sunrise = json['sunrise'] as String;
    sunset = json['sunset'] as String;
    moonphase = json['moon_phase'] as String;
  }

  late final String sunrise;
  late final String sunset;
  late final String moonphase;
}

class Hour {
  Hour({
    required this.timeEpoch,
    required this.time,
    required this.tempC,
    required this.condition,
    required this.humidity,
  });

  Hour.fromJson(MapJson json) {
    timeEpoch = json['time_epoch'] as int;
    time = json['time'] as String;
    tempC = json['temp_c'] as double;
    condition = Condition.fromJson(json['condition'] as MapJson);
    humidity = json['humidity'] as int;
  }

  late final int timeEpoch;
  late final String time;
  late final double? tempC;
  late final Condition condition;
  late final int humidity;
}
