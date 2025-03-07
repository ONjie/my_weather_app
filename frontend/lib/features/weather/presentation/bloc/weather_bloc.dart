import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';
import 'package:weather_app/features/weather/domain/use_cases/fetch_locations_weather_data.dart';
import 'package:weather_app/features/weather/domain/use_cases/fetch_weather_forecast_data.dart';

import '../../domain/entities/location_current_weather_entity.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final FetchWeatherForecast fetchWeatherForcast;
  final FetchLocationsCurrentWeather fetchLocationsCurrentWeather;
  WeatherBloc({
    required this.fetchWeatherForcast,
    required this.fetchLocationsCurrentWeather,
  }) : super(
          const WeatherState(
            weatherStatus: WeatherStatus.intial,
          ),
        ) {
    on<FetchWeatherForecastEvent>(_onFetchWeatherForecast);
    on<FetchLocationsCurrentWeatherEvent>(_onFetchLocationsCurrentWeather);
  }

  _onFetchWeatherForecast(
    FetchWeatherForecastEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(
      const WeatherState(
        weatherStatus: WeatherStatus.loading,
      ),
    );

    final weatherForecastOrFailure = await fetchWeatherForcast.execute();
    if (weatherForecastOrFailure.isLeft) {
      final failure = weatherForecastOrFailure.left;
      emit(
        WeatherState(
          weatherStatus: WeatherStatus.fetchWeatherForecastError,
          errorMessage: _mapFailureToMessage(failure: failure),
        ),
      );
      return;
    }

    final weatherForecast =
        weatherForecastOrFailure.right;

    final locationsCurrentWeatherOrFailure =
        await fetchLocationsCurrentWeather.execute();


    if (locationsCurrentWeatherOrFailure.isLeft) {
      final failure =
          locationsCurrentWeatherOrFailure.left;
      emit(
        WeatherState(
          weatherStatus: WeatherStatus.fetchLocationsCurrentWeatherError,
          weatherForecast: weatherForecast,
          locationsCurrentWeather: const [],
          errorMessage: _mapFailureToMessage(failure: failure),
        ),
      );
      return;
    }

    final locationsCurrentWeather =
        locationsCurrentWeatherOrFailure.right;

    emit(
      WeatherState(
        weatherStatus: WeatherStatus.weatherForecastLoaded,
        weatherForecast: weatherForecast,
        locationsCurrentWeather: locationsCurrentWeather,
      ),
    );
  }

  _onFetchLocationsCurrentWeather(
    FetchLocationsCurrentWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(
      const WeatherState(
        weatherStatus: WeatherStatus.locationsCurrentWeatherLoading,
      ),
    );

    final locationsCurrentWeatherOrFailure =
        await fetchLocationsCurrentWeather.execute();

    locationsCurrentWeatherOrFailure.fold(
      (failure) {
        emit(
          WeatherState(
            weatherStatus: WeatherStatus.fetchLocationsCurrentWeatherError,
            errorMessage: _mapFailureToMessage(failure: failure),
          ),
        );
      },
      (locationsCurrentWeather) {
        emit(
          WeatherState(
            weatherStatus: WeatherStatus.locationsCurrentWeatherLoaded,
            locationsCurrentWeather: locationsCurrentWeather,
          ),
        );
      },
    );
  }
}

String _mapFailureToMessage({required failure}) {
  if (failure is InternetConnectionFailure) {
    return failure.message;
  } else if (failure is LocationServicesFailure) {
    return failure.message;
  } else if (failure is ServerFailure) {
    return failure.message;
  } else if (failure is OtherFailure) {
    return failure.message;
  } else if (failure is DatabaseFailure) {
    return failure.message;
  } else {
    return 'Unknown Error';
  }
}
