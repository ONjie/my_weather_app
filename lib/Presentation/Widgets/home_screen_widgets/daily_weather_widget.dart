import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Data/Models/weather_data_model.dart';
import '../../Constants/colors.dart';

class DailyWeatherWidget extends StatelessWidget {
  const DailyWeatherWidget({super.key, required this.dailyWeatherData});
  
  final WeatherData dailyWeatherData;

  @override
  Widget build(BuildContext context) {
    return buildDailyWeatherDetailsCard(context: context);
  }

  Widget buildDailyWeatherDetailsCard({required BuildContext context}) => Card(
        color: cardOnLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
          child: buildListView(context: context),
        ),
      );

  Widget buildListView({required BuildContext context}) => SizedBox(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: dailyWeatherData.forecast.forecastday.length,
          itemBuilder: (context, index) {
              String date = DateFormat('Md').format(DateTime.parse(dailyWeatherData.forecast.forecastday[index].date));
              String dateEpoch = DateFormat('EE').format(DateTime.parse(dailyWeatherData.forecast.forecastday[index].date));
              String description = dailyWeatherData.forecast.forecastday[index].day.condition.text.replaceAll('possible', '');
              int? maxtempC = dailyWeatherData.forecast.forecastday[index].day.maxtempC?.toInt();
              int? mintempC = dailyWeatherData.forecast.forecastday[index].day.mintempC?.toInt();
              String imageUrl = dailyWeatherData.forecast.forecastday[index].day.condition.icon;

              String today = DateFormat('EE').format(DateTime.now());

              return buildDailyWeatherDetailsTable(
                date: date,
                day: dateEpoch,
                description: description,
                maxtempC: maxtempC,
                mintempC: mintempC,
                imageUrl: imageUrl,
                today: today,
              );
          },
        ),
      );

  Widget buildDailyWeatherDetailsTable({
    required String date,
    required String day,
    required String description,
    required int? mintempC,
    required int? maxtempC,
    required String imageUrl,
    required String today,
  }) => Column(
    children: [
      Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                '$date\t\t${day == today ? 'Today' : day}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              width: 180,
              child: Row(
                children: [
                  Image.network(
                    'https:$imageUrl',
                    width: 30,
                    alignment: Alignment.center,
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Text(
                '${maxtempC.toString()}\u00B0\t\t${mintempC.toString()}\u00B0',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
