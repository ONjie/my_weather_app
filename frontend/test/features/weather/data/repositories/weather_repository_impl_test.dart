import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/exceptions/exceptions.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/core/services/location_services.dart';
import 'package:weather_app/features/locations/data/data_sources/local_data_source/favorite_locations_local_data_source.dart';
import 'package:weather_app/features/locations/data/models/favorite_location_model.dart';
import 'package:weather_app/features/weather/data/data_sources/remote_data_source/weather_api.dart';
import 'package:weather_app/features/weather/data/models/location_current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/weather_forecast_model.dart'
    as prefix;
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/entities/location_current_weather_entity.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';

import 'weather_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NetworkInfo>()])
@GenerateNiceMocks([MockSpec<LocationServices>()])
@GenerateNiceMocks([MockSpec<WeatherApi>()])
@GenerateNiceMocks([MockSpec<FavoriteLocationsLocalDataSource>()])
const noInternetConncetionMessage = 'No Internet Connection.';
const disabledLocationServiceMessage = 'Location services are disabled.';
const notFoundServerMessage = 'Not Found.';
const unExpectedErrorMessage = 'Unexpected error.';
void main() {
  late WeatherRepositoryImpl weatherDataRepositoryImpl;
  late MockWeatherApi mockWeatherApi;
  late MockNetworkInfo mockNetworkInfo;
  late MockLocationServices mockLocationServices;
  late MockFavoriteLocationsLocalDataSource
      mockFavoriteLocationsLocalDataSource;

  setUp(() {
    mockWeatherApi = MockWeatherApi();
    mockNetworkInfo = MockNetworkInfo();
    mockLocationServices = MockLocationServices();
    mockFavoriteLocationsLocalDataSource =
        MockFavoriteLocationsLocalDataSource();

    weatherDataRepositoryImpl = WeatherRepositoryImpl(
      weatherApi: mockWeatherApi,
      networkInfo: mockNetworkInfo,
      locationServices: mockLocationServices,
      favoriteLocationsLocalDataSource: mockFavoriteLocationsLocalDataSource,
    );
  });

  void runOnlineTest(Function body) {
    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runOfflineTest(Function body) {
    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('fetchWeatherForecast', () {
    final tPosition = Position(
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
      speedAccuracy: 0.0,
    );

    const tTemp = prefix.TempModel(
      maxTemp: 23.06,
      minTemp: 19.15,
    );

    const tWeather = prefix.WeatherModel(
      description: 'clear sky',
      icon: '01n',
    );

    const tDaily = prefix.DailyModel(
      dateTimestamp: 1739883600,
      sunriseTimestamp: 1739863686,
      sunsetTimestamp: 1739905959,
      temp: tTemp,
      weather: [tWeather],
    );

    const tHourly = prefix.HourlyModel(
      dateTimestamp: 1739919600,
      temp: 21.95,
      weather: [tWeather],
      humidity: 66,
    );

    const tWeatherForecast = prefix.WeatherForecastModel(
      hourly: [tHourly, tHourly],
      daily: [tDaily, tDaily],
    );

    test('checks if the device online', () async {
      when(
        mockNetworkInfo.isConnected,
      ).thenAnswer(
        (_) async => false,
      );

      weatherDataRepositoryImpl.fetchWeatherForecast();

      verify(mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTest(() {
      test(
          'should return Left(InternetConnectionFailure) when device is offline',
          () async {
        //act
        final result = await weatherDataRepositoryImpl.fetchWeatherForecast();

        //assert
        expect(result, equals(isA<Left<Failure, WeatherForecastEntity>>()));
        expect(
          result.left,
          equals(
            const InternetConnectionFailure(
              message: noInternetConncetionMessage,
            ),
          ),
        );
      });
    });

    runOnlineTest(() {
      test(
          'should return Right(WeatherForecastEntity) when call to WeatherDataApi is successful',
          () async {
        //arrange
        when(
          mockLocationServices.getDeviceLocation(),
        ).thenAnswer(
          (_) async => tPosition,
        );
        when(
          mockWeatherApi.fetchWeatherForecast(
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).thenAnswer(
          (_) async => tWeatherForecast,
        );

        //act
        final result = await weatherDataRepositoryImpl.fetchWeatherForecast();

        //assert
        expect(
          result,
          equals(
            isA<Right<Failure, WeatherForecastEntity>>(),
          ),
        );
        expect(
          result.right,
          equals(tWeatherForecast.toWeatherForecastEntity()),
        );
        verify(
          mockLocationServices.getDeviceLocation(),
        ).called(1);
        verify(
          mockWeatherApi.fetchWeatherForecast(
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockLocationServices);
        verifyNoMoreInteractions(mockWeatherApi);
      });

      test(
          'should return Left(LocationServicesFailure) when LocationServicesException is thrown',
          () async {
        //arrange
        when(
          mockLocationServices.getDeviceLocation(),
        ).thenThrow(
            LocationServicesException(message: disabledLocationServiceMessage));

        //act
        final result = await weatherDataRepositoryImpl.fetchWeatherForecast();

        //assert
        expect(
          result,
          equals(
            isA<Left<Failure, WeatherForecastEntity>>(),
          ),
        );
        expect(
          result.left,
          equals(
            const LocationServicesFailure(
              message: disabledLocationServiceMessage,
            ),
          ),
        );
        verify(
          mockLocationServices.getDeviceLocation(),
        ).called(1);
        verifyNoMoreInteractions(mockLocationServices);
      });

      test('should return Left(ServerFailure) when ServerException is thrown',
          () async {
        //arrange
        when(
          mockLocationServices.getDeviceLocation(),
        ).thenAnswer(
          (_) async => tPosition,
        );
        when(
          mockWeatherApi.fetchWeatherForecast(
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).thenThrow(
          ServerException(
            message: notFoundServerMessage,
          ),
        );

        //act
        final result = await weatherDataRepositoryImpl.fetchWeatherForecast();

        //assert
        expect(
          result,
          equals(
            isA<Left<Failure, WeatherForecastEntity>>(),
          ),
        );
        expect(
          result.left,
          equals(
            const ServerFailure(
              message: notFoundServerMessage,
            ),
          ),
        );
        verify(
          mockLocationServices.getDeviceLocation(),
        ).called(1);
        verify(
          mockWeatherApi.fetchWeatherForecast(
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockLocationServices);
        verifyNoMoreInteractions(mockWeatherApi);
      });
      test('should return Left(OtherFailure) when OtherException is thrown',
          () async {
        //arrange
        when(
          mockLocationServices.getDeviceLocation(),
        ).thenAnswer(
          (_) async => tPosition,
        );
        when(
          mockWeatherApi.fetchWeatherForecast(
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).thenThrow(
          OtherException(
            message: unExpectedErrorMessage,
          ),
        );

        //act
        final result = await weatherDataRepositoryImpl.fetchWeatherForecast();

        //assert
        expect(
          result,
          equals(
            isA<Left<Failure, WeatherForecastEntity>>(),
          ),
        );
        expect(
          result.left,
          equals(
            const OtherFailure(
              message: unExpectedErrorMessage,
            ),
          ),
        );
        verify(
          mockLocationServices.getDeviceLocation(),
        ).called(1);
        verify(
          mockWeatherApi.fetchWeatherForecast(
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockLocationServices);
        verifyNoMoreInteractions(mockWeatherApi);
      });
    });
  });

  group('fetchLocationCurrentWeather', () {
    const tLocationName = 'Banjul';
    const tWeather = WeatherModel(
      icon: '01n',
    );

    const tCurrent = CurrentModel(
      dateTimestamp: 1739934864,
      temp: 21.15,
      weather: [tWeather],
    );

    const tLocationCurrentWeather = LocationCurrentWeatherModel(
      current: tCurrent,
      locationName: tLocationName,
      timezoneOffset: 0,
    );

    const tFavoriteLocation = FavoriteLocationModel(
      id: 1,
      locationName: 'Banjul',
      country: 'Gambia',
      latitude: 13.4531,
      longitude: -16.5775,
    );

    test('checks if the device online', () async {
      when(
        mockNetworkInfo.isConnected,
      ).thenAnswer(
        (_) async => false,
      );

      weatherDataRepositoryImpl.fetchLocationCurrentWeather();

      verify(mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTest(() {
      test(
          'should return Left(InternetConnectionFailure) when device is offline',
          () async {
        //act
        final result =
            await weatherDataRepositoryImpl.fetchLocationCurrentWeather();

        //assert
        expect(result,
            equals(isA<Left<Failure, List<LocationCurrentWeatherEntity>>>()));
        expect(
          result.left,
          equals(const InternetConnectionFailure(
            message: noInternetConncetionMessage,
          )),
        );
      });
    });

    runOnlineTest(() {
      test(
          'should return Left(DatabaseFailure) when List<FavoriteLocationModel> is empty',
          () async {
        //arrange
        when(
          mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
        ).thenAnswer(
          (_) async => [],
        );

        //act
        final result =
            await weatherDataRepositoryImpl.fetchLocationCurrentWeather();

        //assert
        expect(
          result,
          equals(
            isA<Left<Failure, List<LocationCurrentWeatherEntity>>>(),
          ),
        );
        expect(
          result.left,
          equals(
            const DatabaseFailure(
              message: 'No favorite locations found',
            ),
          ),
        );
        verify(
          mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
        ).called(1);
        verifyNoMoreInteractions(mockFavoriteLocationsLocalDataSource);
      });

      test(
          'should return Right(List<LocationWeatherEntity>) when call to WeatherApi is successful',
          () async {
        //arrange
        when(
          mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
        ).thenAnswer(
          (_) async => [tFavoriteLocation],
        );
        when(
          mockWeatherApi.fetchLocationCurrentWeather(
            locationName: anyNamed('locationName'),
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).thenAnswer(
          (_) async => tLocationCurrentWeather,
        );

        //act
        final result =
            await weatherDataRepositoryImpl.fetchLocationCurrentWeather();

        //assert
        expect(
          result,
          equals(isA<Right<Failure, List<LocationCurrentWeatherEntity>>>()),
        );
        expect(
          result.right,
          equals([tLocationCurrentWeather.toLocationCurrentWeatherEntity()]),
        );
        verify(
          mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
        ).called(1);
        verify(
          mockWeatherApi.fetchLocationCurrentWeather(
            locationName: anyNamed('locationName'),
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockFavoriteLocationsLocalDataSource);
        verifyNoMoreInteractions(mockWeatherApi);
      });

      test('should return Left(ServerFailure) when ServerException is thrown',
          () async {
        //arrange
        when(
          mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
        ).thenAnswer(
          (_) async => [tFavoriteLocation],
        );
        when(
          mockWeatherApi.fetchLocationCurrentWeather(
            locationName: anyNamed('locationName'),
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).thenThrow(
          ServerException(
            message: notFoundServerMessage,
          ),
        );

        //act
        final result =
            await weatherDataRepositoryImpl.fetchLocationCurrentWeather();

        //assert
        expect(
          result,
          equals(
            isA<Left<Failure, List<LocationCurrentWeatherEntity>>>(),
          ),
        );
        expect(
          result.left,
          equals(
            const ServerFailure(
              message: notFoundServerMessage,
            ),
          ),
        );
        verify(
          mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
        ).called(1);
        verify(
          mockWeatherApi.fetchLocationCurrentWeather(
            locationName: anyNamed('locationName'),
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockFavoriteLocationsLocalDataSource);
        verifyNoMoreInteractions(mockWeatherApi);
      });

      test('should return Left(OtherFailure) when OtherException is thrown',
          () async {
        //arrange
        when(
          mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
        ).thenAnswer(
          (_) async => [tFavoriteLocation],
        );
        when(
          mockWeatherApi.fetchLocationCurrentWeather(
            locationName: anyNamed('locationName'),
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).thenThrow(
          OtherException(
            message: unExpectedErrorMessage,
          ),
        );

        //act
        final result =
            await weatherDataRepositoryImpl.fetchLocationCurrentWeather();

        //assert
        expect(
          result,
          equals(
            isA<Left<Failure, List<LocationCurrentWeatherEntity>>>(),
          ),
        );
        expect(
          result.left,
          equals(
            const OtherFailure(
              message: unExpectedErrorMessage,
            ),
          ),
        );
        verify(
          mockFavoriteLocationsLocalDataSource.fetchFavoriteLocations(),
        ).called(1);
        verify(
          mockWeatherApi.fetchLocationCurrentWeather(
            locationName: anyNamed('locationName'),
            lat: anyNamed('lat'),
            lon: anyNamed('lon'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockFavoriteLocationsLocalDataSource);
        verifyNoMoreInteractions(mockWeatherApi);
      });
    });
  });
}
