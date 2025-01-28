class WeatherApiException implements Exception {
  WeatherApiException({required this.message});
  final String? message;
}

class OtherExceptions implements Exception {
  OtherExceptions({required this.message});

  final String? message;
}
