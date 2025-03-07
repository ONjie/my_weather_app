import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/time_converters/timestamp_converter.dart';
import 'package:weather_app/features/weather/domain/entities/weather_forecast_entity.dart';

class SunRiseSunSetWidget extends StatelessWidget {
  const SunRiseSunSetWidget({super.key, required this.weatherForecast});
  final WeatherForecastEntity weatherForecast;

  @override
  Widget build(BuildContext context) {
    final sunRiseTimestamp = weatherForecast.daily[0].sunriseTimestamp;
    final sunSetTimestamp = weatherForecast.daily[0].sunsetTimestamp;

    String sunRiseTime = timeStampConverter(
      format: 'Hm',
      timestamp: sunRiseTimestamp,
    );
    String sunSetTime = timeStampConverter(
      format: 'Hm',
      timestamp: sunSetTimestamp,
    );

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildSunRiseSunSetRowWiget(
              title: 'Sunrise',
              time: sunRiseTime,
              iconUrl: 'assets/images/113.png',
              iconWidth: 35,
              context: context,
            ),
            buildSunRiseSunSetRowWiget(
              title: 'Sunset',
              time: sunSetTime,
              iconUrl: 'assets/images/moon2.png',
              iconWidth: 19,
              iconColor: Theme.of(context).colorScheme.tertiary,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildSunRiseSunSetRowWiget({
  required String title,
  required String time,
  required String iconUrl,
  Color? iconColor,
  required double iconWidth,
  required BuildContext context,
}) {
  return Row(
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      const SizedBox(width: 12),
      Image.asset(
        iconUrl,
        width: iconWidth,
        color: iconColor,
      ),
      const SizedBox(width: 5),
      Text(
        time,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ],
  );
}
