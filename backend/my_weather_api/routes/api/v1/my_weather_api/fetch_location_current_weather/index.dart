import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_weather_api/src/my_weather_api/repositories/my_weather_api_repository.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final prams = context.request.uri.queryParameters;

  final lat = double.tryParse(prams['lat'] ?? '');
  final lon = double.tryParse(prams['lon'] ?? '');
  final locationName = prams['location_name'] ?? '';

  if (lat == null || lon == null || locationName.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'lat, lon and location name are required'},
    );
  }

  final myWeatherApiRepository = context.read<MyWeatherApiRepository>();

  final locationCurrentWeatherOrFailure =
      await myWeatherApiRepository.fetchLocationCurrentWeather(
    lat: lat,
    lon: lon,
  );

  return locationCurrentWeatherOrFailure.fold(
    (failure) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': failure.message},
      );
    },
    (locationCurrentWeather) {
      return Response.json(
        body: {
          'location_name': locationName,
          'current_weather': locationCurrentWeather.toJson(),
        },
      );
    },
  );
}
