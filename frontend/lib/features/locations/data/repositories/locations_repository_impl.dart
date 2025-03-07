import 'package:either_dart/either.dart';
import 'package:weather_app/core/exceptions/exceptions.dart';

import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/core/utils/response.dart';
import 'package:weather_app/features/locations/data/data_sources/local_data_source/favorite_locations_local_data_source.dart';
import 'package:weather_app/features/locations/data/data_sources/remote_data_source/places_api.dart';

import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';

import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/locations_repository.dart';
import '../models/favorite_location_model.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  LocationsRepositoryImpl({
    required this.favoriteLocationsLocalDataSource,
    required this.networkInfo,
    required this.locationsApi,
  });

  final FavoriteLocationsLocalDataSource favoriteLocationsLocalDataSource;
  final NetworkInfo networkInfo;
  final PlacesApi locationsApi;
  @override
  Future<Either<Failure, int>> addFavoriteLocation({
    required FavoriteLocationEntity favoriteLocation,
  }) async {
    try {
      final favoriteLocationToBeAdded =
          FavoriteLocationModel.fromLocationEntity(
        favoriteLocation: favoriteLocation,
      );

      final generatedId =
          await favoriteLocationsLocalDataSource.addFavoriteLocation(
        favoriteLocation: favoriteLocationToBeAdded,
      );

      if (generatedId <= 0) {
        return const Left(
          DatabaseFailure(
            message: 'Failed to add favorite location',
          ),
        );
      }
      return Right(generatedId);
    } catch (e) {
      return Left(OtherFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFavoriteLocation({
    required int id,
  }) async {
    try {
      final isDeleted =
          await favoriteLocationsLocalDataSource.deleteFavoriteLocation(
        id: id,
      );
      if (!isDeleted) {
        return const Left(
          DatabaseFailure(
            message: 'Failed to delete favorite location',
          ),
        );
      }
      return Right(isDeleted);
    } catch (e) {
      return Left(OtherFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FavoriteLocationEntity>>>
      fetchFavoriteLocations() async {
    try {
      final fetchedFavoriteLocations =
          await favoriteLocationsLocalDataSource.fetchFavoriteLocations();

      if (fetchedFavoriteLocations.isEmpty) {
        return const Left(
          DatabaseFailure(
            message: 'No favorite locations found',
          ),
        );
      }

      final favoriteLocations = fetchedFavoriteLocations
          .map(
            (favoriteLocation) => favoriteLocation.toFavoriteLocationEntity(),
          )
          .toList();

      return Right(favoriteLocations);
    } catch (e) {
      return Left(OtherFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocationEntity>> fetchLocationsSuggestions({
    required String locationName,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        InternetConnectionFailure(
          message: noInternetConnection,
        ),
      );
    }

    try {
      final result = await locationsApi.fetchLocationsSuggestions(
        locationName: locationName,
      );
      final locationEntity = result.toLocationEntity();

      return Right(locationEntity);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
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
