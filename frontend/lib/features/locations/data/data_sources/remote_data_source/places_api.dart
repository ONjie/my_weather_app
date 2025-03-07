import 'package:dio/dio.dart';
import 'package:weather_app/core/exceptions/exceptions.dart';
import 'package:weather_app/core/utils/urls/urls.dart';
import 'dart:io';
import 'package:weather_app/features/locations/data/models/location_model.dart';

abstract class PlacesApi {
  Future<LocationModel> fetchLocationsSuggestions(
      {required String locationName});
}

class PlacesApiImpl implements PlacesApi {
  PlacesApiImpl({required this.dio});

  final Dio dio;

  @override
  Future<LocationModel> fetchLocationsSuggestions(
      {required String locationName}) async {
    try {
      final response = await dio.get(
        '$baseUrl/$placeAutocompleteUrl',
        queryParameters: {
          'location_name': locationName,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return LocationModel.fromJson(response.data);
      } else {
        throw ServerException(message: response.data['error'] as String);
      }
    } catch (e) {
      
      if (e is ServerException) {
        rethrow;
      } else {
        throw OtherException(message: e.toString());
      }
    }
  }
}
