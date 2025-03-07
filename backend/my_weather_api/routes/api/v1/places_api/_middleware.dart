import 'package:dart_frog/dart_frog.dart';
import 'package:dio/dio.dart';
import 'package:my_weather_api/src/places_api/data_sources/remote_data_source/places_api.dart';
import 'package:my_weather_api/src/places_api/repositories/places_api_repository.dart';

final _placesApiImpl = PlacesApiImpl(dio: Dio());
final _placesApiRepositoryImpl = PlacesApiRepositoryImpl(
  placesApi: _placesApiImpl,
);

Handler middleware(Handler handler) {
  return handler
      .use(
        provider<PlacesApiRepository>(
          (context) => _placesApiRepositoryImpl,
        ),
      )
      .use(
        provider<PlacesApi>(
          (context) => _placesApiImpl,
        ),
      );
}
