import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_weather_api/src/weather_api/repositories/weather_api_repository.dart';

Future<Response> onRequest(RequestContext context, String locationName) {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context, locationName),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onGet(RequestContext context, String locationName) async {
  final weatherApiRepository = context.read<WeatherApiRepository>();

  final locationWeatherDataOrFailure =
      await weatherApiRepository.getLocationWeatherData(
    locationName: locationName,
  );

  return locationWeatherDataOrFailure.fold((failure) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': failure.message},
    );
  }, (locationWeatherData) {
    return Response.json(
      body: {
        'location_name': locationWeatherData.locationName,
        'localtime_epoch': locationWeatherData.localtimeEpoch,
        'localtime': locationWeatherData.localtime,
        'temp_c': locationWeatherData.tempC,
        'icon': locationWeatherData.icon,
        'country': locationWeatherData.country,
      },
    );
  });
}
