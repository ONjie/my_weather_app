import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/utils/time_converters/timestamp_converter.dart';
import 'package:weather_app/core/utils/urls/urls.dart';

import '../../../domain/entities/weather_forecast_entity.dart';

class DailyWeatherWidget extends StatelessWidget {
  const DailyWeatherWidget({super.key, required this.weatherForecast});

  final WeatherForecastEntity weatherForecast;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: buildDailyWeatherListView(context: context),
      ),
    );
  }

  Widget buildDailyWeatherListView({
    required BuildContext context,
  }) {
    return SizedBox(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount:
            weatherForecast.daily.length < 7 ? weatherForecast.daily.length : 7,
        separatorBuilder: (context, index) => const SizedBox(
          height: 12,
        ),
        itemBuilder: (context, index) {
          String date = timeStampConverter(
            format: 'dd/MM',
            timestamp: weatherForecast.daily[index].dateTimestamp,
          );
          String dateEpoch = timeStampConverter(
            format: 'EE',
            timestamp: weatherForecast.daily[index].dateTimestamp,
          );
          String description =
              weatherForecast.daily[index].weather[0].description;
          int maxtempC = weatherForecast.daily[index].temp.maxTemp.toInt();
          int mintempC = weatherForecast.daily[index].temp.minTemp.toInt();
          String imageUrl = weatherForecast.daily[index].weather[0].icon;

          String today = DateFormat('EE').format(DateTime.now());

          return buildDailyWeatherDetails(
              date: date,
              day: dateEpoch,
              description: description,
              maxtempC: maxtempC,
              mintempC: mintempC,
              imageUrl: imageUrl,
              today: today,
              context: context);
        },
      ),
    );
  }

  Widget buildDailyWeatherDetails({
    required String date,
    required String day,
    required String description,
    required int mintempC,
    required int maxtempC,
    required String imageUrl,
    required String today,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.30,
          child: Text(
            '$date\t\t${day == today ? 'Today' : day}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.30,
          child: Row(
            children: [
              Image.network(
                '$openWeatherMapIconUrl$imageUrl.png',
                width: 30,
                alignment: Alignment.center,
              ),
              Flexible(
                child: Text(
                  description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: Text(
            '${maxtempC.toString()}\u00B0\t\t${mintempC.toString()}\u00B0',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
