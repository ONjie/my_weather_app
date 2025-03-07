import 'package:either_dart/either.dart';
import 'package:weather_app/core/exceptions/exceptions.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/core/services/location_services.dart';
import 'package:weather_app/features/locations/data/data_sources/local_data_source/favorite_locations_local_data_source.dart';
import 'package:weather_app/features/weather/data/data_sources/remote_data_source/weather_api.dart';
import 'package:weather_app/features/weather/domain/entities/location_current_weather_entity.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

const noInternetConncetionMessage = 'No Internet Connection.';

class WeatherRepositoryImpl implements WeatherRepository {
  final NetworkInfo networkInfo;
  final LocationServices locationServices;
  final WeatherApi weatherApi;
  final FavoriteLocationsLocalDataSource favoriteLocationsLocalDataSource;

  WeatherRepositoryImpl({
    required this.weatherApi,
    required this.networkInfo,
    required this.locationServices,
    required this.favoriteLocationsLocalDataSource,
  });

  @override
  Future<Either<Failure, WeatherForecastEntity>> fetchWeatherForecast() async {
    if (!await networkInfo.isConnected) {
      return const Left(
        InternetConnectionFailure(
          message: noInternetConncetionMessage,
        ),
      );
    }

    try {
      final location = await locationServices.getDeviceLocation();

      final weatherforecastModel = await weatherApi.fetchWeatherForecast(
        lat: location.latitude,
        lon: location.longitude,
      );

      final weatherForecastEntity =
          weatherforecastModel.toWeatherForecastEntity();

      return Right(weatherForecastEntity);
    } on LocationServicesException catch (e) {
      return Left(
        LocationServicesFailure(
          message: e.message!,
        ),
      );
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

  @override
  Future<Either<Failure, List<LocationCurrentWeatherEntity>>>
      fetchLocationCurrentWeather() async {
    if (!await networkInfo.isConnected) {
      return const Left(
        InternetConnectionFailure(
          message: noInternetConncetionMessage,
        ),
      );
    }

    try {
      late List<LocationCurrentWeatherEntity> locationsWeatherList = [];

      final favoriteLocations =
          await favoriteLocationsLocalDataSource.fetchFavoriteLocations();

      if (favoriteLocations.isEmpty) {
        return const Left(
          DatabaseFailure(
            message: 'No favorite locations found',
          ),
        );
      }

      for (final favoriteLocation in favoriteLocations) {
        final locationCurrentWeatherModel =
            await weatherApi.fetchLocationCurrentWeather(
          locationName: favoriteLocation.locationName,
          lat: favoriteLocation.latitude,
          lon: favoriteLocation.longitude,
        );

        final locationWeatherEntity =
            locationCurrentWeatherModel.toLocationCurrentWeatherEntity();

        locationsWeatherList.add(locationWeatherEntity);
      }

      return Right(locationsWeatherList);
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
