// ignore_for_file: avoid_dynamic_calls

class LocationWeatherData {
  LocationWeatherData({
    required this.locationName,
    required this.localtimeEpoch,
    required this.localtime,
    required this.tempC,
    required this.icon,
    required this.country,
  });

  LocationWeatherData.fromJson(Map<String, dynamic> json) {
    locationName = json['location']['name'] as String;
    country = json['location']['country'] as String;
    localtimeEpoch = json['location']['localtime_epoch'] as int;
    localtime = json['location']['localtime'] as String;
    tempC = json['current']['temp_c'] as double;
    icon = json['current']['condition']['icon'] as String;
  }
  late final String locationName;
  late final int localtimeEpoch;
  late final String localtime;
  late final double tempC;
  late final String icon;
  late final String country;
}
