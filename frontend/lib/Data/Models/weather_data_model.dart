class WeatherData {
  WeatherData({
    required this.forecast,
  });
  late final Forecast forecast;

  WeatherData.fromJson(Map<String, dynamic> json){
    forecast = Forecast.fromJson(json['forecast']);
  }
}

class Condition {
  Condition({required this.text, required this.icon,});
  late final String text;
  late final String icon;

  Condition.fromJson(Map<String, dynamic> json){
    text = json['text'];
    icon = json['icon'];
  }

}

class Forecast {
  Forecast({required this.forecastday,});

  late final List<Forecastday> forecastday;

  Forecast.fromJson(Map<String, dynamic> json){
    forecastday = List.from(json['forecastday']).map((e)=>Forecastday.fromJson(e)).toList();
  }

}

class Forecastday {

  Forecastday({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.astro,
    required this.hour,
  });
  late final String date;
  late final int dateEpoch;
  late final Day day;
  late final Astro astro;
  late final List<Hour> hour;

  Forecastday.fromJson(Map<String, dynamic> json){
    date = json['date'];
    dateEpoch = json['date_epoch'];
    day = Day.fromJson(json['day']);
    astro = Astro.fromJson(json['astro']);
    hour = List.from(json['hour']).map((e)=>Hour.fromJson(e)).toList();
  }

}

class Day {

  Day({required this.maxtempC, required this.mintempC,required this.condition,});
  late final double? maxtempC;
  late final double? mintempC;
  late final Condition condition;

  Day.fromJson(Map<String, dynamic> json){
    maxtempC = json['maxtemp_c'];
    mintempC = json['mintemp_c'];
    condition = Condition.fromJson(json['condition']);
  }

}

class Astro {
  Astro({required this.sunrise, required this.sunset, required this.moonphase,});
  late final String sunrise;
  late final String sunset;
  late final String moonphase;

  Astro.fromJson(Map<String, dynamic> json){

    sunrise = json['sunrise'];
    sunset = json['sunset'];
    moonphase = json['moon_phase'];
  }

}

class Hour {
  Hour({
    required this.timeEpoch,
    required this.time,
    required this.tempC,
    required this.condition,
    required this.humidity,
  });
  late final int timeEpoch;
  late final String time;
  late final double? tempC;
  late final Condition condition;
  late final int humidity;

  Hour.fromJson(Map<String, dynamic> json){
    timeEpoch = json['time_epoch'];
    time = json['time'];
    tempC = json['temp_c'];
    condition = Condition.fromJson(json['condition']);
    humidity = json['humidity'];
  }
}