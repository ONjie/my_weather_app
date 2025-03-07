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

  if (lat == null || lon == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'lat and lon are required'},
    );
  }

  final myWeatherApiRepository = context.read<MyWeatherApiRepository>();

  final weatherForecastOrFailure =
      await myWeatherApiRepository.fetchWeatherForecast(
    lat: lat,
    lon: lon,
  );

  return weatherForecastOrFailure.fold(
    (failure) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': failure.message},
      );
    },
    (weatherForecast) {
      return Response.json(
        body: weatherForecast.toJson(),
      );
    },
  );
}
