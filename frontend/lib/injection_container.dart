import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_app/core/local_database/database.dart';
import 'package:weather_app/core/services/location_services.dart';
import 'package:weather_app/features/locations/data/data_sources/local_data_source/favorite_locations_local_data_source.dart';
import 'package:weather_app/features/locations/data/data_sources/remote_data_source/places_api.dart';
import 'package:weather_app/features/locations/data/repositories/locations_repository_impl.dart';
import 'package:weather_app/features/locations/domain/repositories/locations_repository.dart';
import 'package:weather_app/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:weather_app/features/weather/data/data_sources/remote_data_source/weather_api.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';

import 'core/network/network_info.dart';
import 'core/utils/theme/bloc/theme_bloc.dart';
import 'features/locations/domain/use_cases/add_favorite_location.dart';
import 'features/locations/domain/use_cases/delete_favorite_location.dart';
import 'features/locations/domain/use_cases/fetch_favorite_locations.dart';
import 'features/locations/domain/use_cases/fetch_locations_suggestions.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/use_cases/fetch_locations_weather_data.dart';
import 'features/weather/domain/use_cases/fetch_weather_forecast_data.dart';

final locator = GetIt.instance;

Future<void> init() async {
  //registering blocs
  locator.registerFactory(
    () => WeatherBloc(
      fetchWeatherForcast: locator(),
      fetchLocationsCurrentWeather: locator(),
    ),
  );

  locator.registerFactory(
    () => LocationsBloc(
      addFavoriteLocation: locator(),
      fetchFavoriteLocations: locator(),
      deleteFavoriteLocation: locator(),
      fetchLocationsSuggestions: locator(),
    ),
  );

  locator.registerFactory(
    () => ThemeBloc(),
  );

  //registering usecases
  locator.registerLazySingleton(
    () => FetchWeatherForecast(
      weatherRepository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => FetchLocationsCurrentWeather(
      weatherRepository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => AddFavoriteLocation(
      favoriteLocationsRepository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => DeleteFavoriteLocation(
      favoriteLocationsRepository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => FetchFavoriteLocations(
      favoriteLocationsRepository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => FetchLocationsSuggestions(
      locationsRepository: locator(),
    ),
  );

  //registering repositories
  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      weatherApi: locator(),
      networkInfo: locator(),
      locationServices: locator(),
      favoriteLocationsLocalDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<LocationsRepository>(
    () => LocationsRepositoryImpl(
      favoriteLocationsLocalDataSource: locator(),
      networkInfo: locator(),
      locationsApi: locator(),
    ),
  );

  //registering datasources
  locator.registerLazySingleton<WeatherApi>(
    () => WeatherApiImpl(
      dio: locator(),
    ),
  );

  locator.registerLazySingleton<PlacesApi>(
    () => PlacesApiImpl(
      dio: locator(),
    ),
  );

  locator.registerLazySingleton<FavoriteLocationsLocalDataSource>(
    () => FavoriteLocationsLocalDataSourceImpl(
      appDatabase: locator(),
    ),
  );

  //registering external dependencies
  locator.registerLazySingleton(
    () => Dio(),
  );
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectionChecker: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => InternetConnectionChecker(),
  );

  locator.registerLazySingleton(
    () => AppDatabase(),
  );

  //registering location services
  locator.registerLazySingleton<LocationServices>(
    () => LocationServicesImpl(),
  );
}
