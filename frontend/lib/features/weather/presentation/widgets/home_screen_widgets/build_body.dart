import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';
import 'package:weather_app/features/weather/presentation/widgets/home_screen_widgets/daily_weather_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/home_screen_widgets/hourly_weather_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/home_screen_widgets/sun_rise_sun_set_widget.dart';
import '../../../domain/entities/location_current_weather_entity.dart';
import 'favorite_locations_weather_card_widget.dart';

class BuildBody extends StatelessWidget {
  const BuildBody({
    super.key,
    required this.weatherData,
    required this.locationsCurrentWeather,
    this.errorMessage,
  });

  final WeatherForecastEntity weatherData;
  final List<LocationCurrentWeatherEntity> locationsCurrentWeather;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              16,
              12,
              0,
            ),
            child: Column(
              children: [
                FavoriteLocationsWeatherCardWidget(
                  locationsCurrentWeather: locationsCurrentWeather,
                  errorMessage: errorMessage,
                ),
                const SizedBox(
                  height: 12,
                ),
                HourlyWeatherWidget(weatherForecast: weatherData),
                const SizedBox(
                  height: 12,
                ),
                SunRiseSunSetWidget(weatherForecast: weatherData),
                const SizedBox(
                  height: 12,
                ),
                DailyWeatherWidget(weatherForecast: weatherData),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
