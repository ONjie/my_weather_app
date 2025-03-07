import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/utils/common_widgets/error_state_widget.dart';
import 'package:weather_app/core/utils/common_widgets/loading_widget.dart';
import 'package:weather_app/features/weather/domain/entities/location_current_weather_entity.dart';
import 'package:weather_app/features/weather/presentation/screens/locations_drawer_screen.dart';
import '../../domain/entities/weather_forecast_entity.dart';
import '../bloc/weather_bloc.dart';
import '../widgets/home_screen_widgets/build_app_bar.dart';
import '../widgets/home_screen_widgets/build_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late int tapCount = 0;

  @override
  void initState() {
    BlocProvider.of<WeatherBloc>(context).add(FetchWeatherForecastEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        tapCount++;
        if (tapCount == 1) {
        } else if (tapCount == 2) {
          exit(0);
        } else {
          tapCount = 0;
        }
      },
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state.weatherStatus == WeatherStatus.loading) {
            return const LoadingWidget();
          }
          if (state.weatherStatus == WeatherStatus.weatherForecastLoaded) {
            return buildScaffold(
              dateTimeStamp: state.weatherForecast!.daily[0].dateTimestamp,
              weatherData: state.weatherForecast!,
              locationsWeather: state.locationsCurrentWeather!,
            );
          }
          if (state.weatherStatus ==
              WeatherStatus.fetchLocationsCurrentWeatherError) {
            return buildScaffold(
              dateTimeStamp: state.weatherForecast!.daily[0].dateTimestamp,
              weatherData: state.weatherForecast!,
              locationsWeather: state.locationsCurrentWeather!,
              errorMessage: state.errorMessage!,
            );
          }
          if (state.weatherStatus == WeatherStatus.fetchWeatherForecastError) {
            return ErrorStateWidget(
              errorMessage: state.errorMessage!,
              onPressed: () {
                BlocProvider.of<WeatherBloc>(context)
                    .add(FetchWeatherForecastEvent());
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget buildScaffold({
    required int dateTimeStamp,
    required WeatherForecastEntity weatherData,
    required List<LocationCurrentWeatherEntity> locationsWeather,
    String? errorMessage,
  }) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: buildAppBar(
        dateTimestamp: dateTimeStamp,
        context: context,
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      body: locationsWeather.isEmpty
          ? BuildBody(
              weatherData: weatherData,
              locationsCurrentWeather: locationsWeather,
              errorMessage: errorMessage,
            )
          : BuildBody(
              weatherData: weatherData,
              locationsCurrentWeather: locationsWeather,
            ),
      drawer: locationsWeather.isEmpty
          ? LocationsDrawerScreen(
              locationsCurrentWeather: locationsWeather,
              errorMessage: errorMessage,
            )
          : LocationsDrawerScreen(
              locationsCurrentWeather: locationsWeather,
            ),
    );
  }
}
