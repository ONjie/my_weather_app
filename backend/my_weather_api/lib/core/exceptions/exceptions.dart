class WeatherApiException implements Exception {
  WeatherApiException({required this.message});
  final String? message;
}

class OtherException implements Exception {
  OtherException({required this.message});

  final String? message;
}

class OpenWeatherMapApiException implements Exception {
  OpenWeatherMapApiException({required this.message});

  final String? message;
}

class PlacesApiException implements Exception {
  PlacesApiException({required this.message});

  final String? message;
}
