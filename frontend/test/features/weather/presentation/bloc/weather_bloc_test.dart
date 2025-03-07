import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/weather/domain/entities/location_current_weather_entity.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart' as prefix;
import 'package:weather_app/features/weather/domain/use_cases/fetch_locations_weather_data.dart';
import 'package:weather_app/features/weather/domain/use_cases/fetch_weather_forecast_data.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';

import 'weather_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FetchWeatherForecast>()])
@GenerateNiceMocks([MockSpec<FetchLocationsCurrentWeather>()])
void main() {
  late WeatherBloc weatherBloc;
  late MockFetchWeatherForecast mockFetchWeatherForecast;
  late MockFetchLocationsCurrentWeather mockFetchLocationsCurrentWeather;

  setUp(() {
    mockFetchWeatherForecast = MockFetchWeatherForecast();
    mockFetchLocationsCurrentWeather = MockFetchLocationsCurrentWeather();
    weatherBloc = WeatherBloc(
      fetchWeatherForcast: mockFetchWeatherForecast,
      fetchLocationsCurrentWeather: mockFetchLocationsCurrentWeather,
    );
  });

  const tLocationName = 'Banjul';

    const tTemp = prefix.TempEntity(
      maxTemp: 23.06,
      minTemp: 19.15,
    );

    const tWeather = prefix.WeatherEntity(
      description: 'clear sky',
      icon: '01n',
    );

    const tDaily = prefix.DailyEntity(
      dateTimestamp: 1739883600,
      sunriseTimestamp: 1739863686,
      sunsetTimestamp: 1739905959,
      temp: tTemp,
      weather: [tWeather],
    );

    const tHourly = prefix.HourlyEntity(
      dateTimestamp: 1739919600,
      temp: 21.95,
      weather: [tWeather],
      humidity: 66,
    );

    const tWeatherForecast = prefix.WeatherForecastEntity(
      hourly: [tHourly, tHourly],
      daily: [tDaily, tDaily],
    );

  const tWeatherEntity = WeatherEntity(
      icon: '01n',
    );

    const tCurrent = CurrentEntity(
      dateTimestamp: 1739934864,
      temp: 21.15,
      weather: [tWeatherEntity],
    );

    const tLocationCurrentWeather = LocationCurrentWeatherEntity(
      current: tCurrent,
      locationName: tLocationName,
      timezoneOffset: 0,
    );


  provideDummy<Either<Failure, prefix.WeatherForecastEntity>>(
      const Right(tWeatherForecast));

  provideDummy<Either<Failure, List<LocationCurrentWeatherEntity>>>(
    const Right(
      [tLocationCurrentWeather],
    ),
  );

  group('_onFetchWeatherForecast', () {
    blocTest(
      'should emit[Loading, FetchWeatherForecastError] when fetchWeatherForcast is unsuccessful',
      setUp: () {
        when(
          mockFetchWeatherForecast.execute(),
        ).thenAnswer(
          (_) async => const Left(
            ServerFailure(
              message: 'server down.',
            ),
          ),
        );
      },
      build: () => weatherBloc,
      act: (bloc) => weatherBloc.add(FetchWeatherForecastEvent()),
      expect: () => <WeatherState>[
        const WeatherState(
          weatherStatus: WeatherStatus.loading,
        ),
        const WeatherState(
          weatherStatus: WeatherStatus.fetchWeatherForecastError,
          errorMessage: 'server down.',
        ),
      ],
    );

    blocTest(
      'should emit[Loading, FetchLocationsCurrentWeatherError] when fetchLocationsCurrentWeather is unsuccessful',
      setUp: () {
        when(
          mockFetchWeatherForecast.execute(),
        ).thenAnswer(
          (_) async => const Right(tWeatherForecast),
        );
        when(
          mockFetchLocationsCurrentWeather.execute(),
        ).thenAnswer(
          (_) async => const Left(
            ServerFailure(
              message: 'server down.',
            ),
          ),
        );
      },
      build: () => weatherBloc,
      act: (bloc) => weatherBloc.add(FetchWeatherForecastEvent()),
      expect: () => <WeatherState>[
        const WeatherState(
          weatherStatus: WeatherStatus.loading,
        ),
        const WeatherState(
          weatherStatus: WeatherStatus.fetchLocationsCurrentWeatherError,
          weatherForecast: tWeatherForecast,
          locationsCurrentWeather: [],
          errorMessage: 'server down.',
        ),
      ],
    );

    blocTest(
      'should emit[Loading, WeatherForecastLoaded] when both API calls are successful',
      setUp: () {
        when(
          mockFetchWeatherForecast.execute(),
        ).thenAnswer(
          (_) async => const Right(tWeatherForecast),
        );
        when(
          mockFetchLocationsCurrentWeather.execute(),
        ).thenAnswer(
          (_) async => const Right([tLocationCurrentWeather]),
        );
      },
      build: () => weatherBloc,
      act: (bloc) => weatherBloc.add(FetchWeatherForecastEvent()),
      expect: () => <WeatherState>[
        const WeatherState(
          weatherStatus: WeatherStatus.loading,
        ),
        const WeatherState(
          weatherStatus: WeatherStatus.weatherForecastLoaded,
          weatherForecast: tWeatherForecast,
          locationsCurrentWeather: [tLocationCurrentWeather],
        ),
      ],
    );
  });

  group('_onFetchLocationsCurrentWeather', () {
    blocTest(
      'should emit[LocationsWeatherLoading, FetchLocationsCurrentWeatherError] when unsuccessful',
      setUp: () {
        when(
          mockFetchLocationsCurrentWeather.execute(),
        ).thenAnswer(
          (_) async => const Left(
            ServerFailure(
              message: 'server down.',
            ),
          ),
        );
      },
      build: () => weatherBloc,
      act: (bloc) => weatherBloc.add(FetchLocationsCurrentWeatherEvent()),
      expect: () => <WeatherState>[
        const WeatherState(
          weatherStatus: WeatherStatus.locationsCurrentWeatherLoading,
        ),
        const WeatherState(
          weatherStatus: WeatherStatus.fetchLocationsCurrentWeatherError,
          errorMessage: 'server down.',
        ),
      ],
    );

    blocTest(
      'should emit[LocationsWeatherLoading, LocationsCurrentWeatherLoaded] when successful',
      setUp: () {
        when(
          mockFetchLocationsCurrentWeather.execute(),
        ).thenAnswer(
          (_) async => const Right([tLocationCurrentWeather]),
        );
      },
      build: () => weatherBloc,
      act: (bloc) => weatherBloc.add(FetchLocationsCurrentWeatherEvent()),
      expect: () => <WeatherState>[
        const WeatherState(
          weatherStatus: WeatherStatus.locationsCurrentWeatherLoading,
        ),
        const WeatherState(
          weatherStatus: WeatherStatus.locationsCurrentWeatherLoaded,
          locationsCurrentWeather: [tLocationCurrentWeather],
        ),
      ],
    );
  });
}
