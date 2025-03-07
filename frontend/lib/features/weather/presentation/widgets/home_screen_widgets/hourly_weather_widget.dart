import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/urls/urls.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';

import '../../../../../core/utils/time_converters/timestamp_converter.dart';

class HourlyWeatherWidget extends StatelessWidget {
  const HourlyWeatherWidget({
    super.key,
    required this.weatherForecast,
  });
  final WeatherForecastEntity weatherForecast;

  @override
  Widget build(BuildContext context) {
    final hourlyWeather = weatherForecast.hourly;
    return SizedBox(
      height: 175,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: hourlyWeather.length,
        itemBuilder: (context, index) {
          return buildHourlyWeatherCard(
            time: timeStampConverter(
              format: 'Hm',
              timestamp: hourlyWeather[index].dateTimestamp,
            ),
            icon: hourlyWeather[index].weather[0].icon,
            tempC: hourlyWeather[index].temp,
            humdity: hourlyWeather[index].humidity,
            context: context,
          );
        },
      ),
    );
  }

  Widget buildHourlyWeatherCard({
    required String time,
    required String icon,
    required double tempC,
    required int humdity,
    required BuildContext context,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          8,
          8,
          8,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            '${DateTime.now().hour.toString().padLeft(2, '0')}:00' == time
                ? Text(
                    'Now',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : Text(
                    time,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
            const SizedBox(height: 5),
            Image.network(
              '$openWeatherMapIconUrl$icon.png',
              height: 50,
              width: 50,
            ),
            const SizedBox(height: 5),
            Text(
              '${tempC.toInt()}\u00B0',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Image.asset(
                  'assets/images/humidity_icon.png',
                  height: 15,
                  width: 15,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 5),
                Text(
                  '$humdity%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
