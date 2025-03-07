import 'package:either_dart/either.dart';
import 'package:my_weather_api/core/exceptions/exceptions.dart';
import 'package:my_weather_api/core/failures/failures.dart';
import 'package:my_weather_api/src/places_api/data_sources/remote_data_source/places_api.dart';
import 'package:my_weather_api/src/places_api/models/place_model.dart';

abstract class PlacesApiRepository {
  Future<Either<Failure, PlaceModel>> fetchPlaceSuggestions({
    required String locationName,
  });
}

class PlacesApiRepositoryImpl implements PlacesApiRepository {
  PlacesApiRepositoryImpl({
    required this.placesApi,
  });
  final PlacesApi placesApi;

  @override
  Future<Either<Failure, PlaceModel>> fetchPlaceSuggestions({
    required String locationName,
  }) async {
    try {
      final placeModel = await placesApi.fetchPlaceSuggestions(
        locationName: locationName,
      );
      return Right(placeModel);
    } on PlacesApiException catch (e) {
      return Left(
        PlacesApiFailure(
          message: e.message!,
        ),
      );
    } on OtherException catch (e) {
      return Left(
        OtherFailure(
          message: e.message!,
        ),
      );
    }
  }
}
