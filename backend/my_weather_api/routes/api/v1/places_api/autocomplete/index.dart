import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_weather_api/src/places_api/repositories/places_api_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final prams = context.request.uri.queryParameters;

  final locationName = prams['location_name'] ?? '';

  if (locationName.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'location name is required'},
    );
  }

  final placesApiRepository = context.read<PlacesApiRepository>();

  final placeOrFailure = await placesApiRepository.fetchPlaceSuggestions(
    locationName: locationName,
  );

  return placeOrFailure.fold(
    (failure) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': failure.message},
      );
    },
    (places) {
      return Response.json(
        body: places.toJson(),
      );
    },
  );
}
