import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/core/utils/geoapify_api_urls.dart';
import 'package:my_weather_api/env/env.dart';
import 'package:my_weather_api/src/places_api/models/place_model.dart';

abstract class PlacesApi {
  Future<PlaceModel> fetchPlaceSuggestions({
    required String locationName,
  });
}

class PlacesApiImpl implements PlacesApi {
  PlacesApiImpl({
    required this.dio,
  });
  final Dio dio;

  @override
  Future<PlaceModel> fetchPlaceSuggestions({
    required String locationName,
  }) async {
    try {
      final response = await dio.get(
        geoapifyBaseUrl,
        queryParameters: {
          'text': locationName,
          'apiKey': Env.geoapifyApiKey,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return PlaceModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw PlacesApiException(
          message: response.data['message'] as String,
        );
      }
    } catch (e) {
      if (e is PlacesApiException) {
        rethrow;
      } else {
        throw OtherException(message: e.toString());
      }
    }
  }
}
