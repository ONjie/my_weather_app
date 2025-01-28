import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Presentation/Constants/colors.dart';

import '../../../Data/Models/weather_data_model.dart';


class HourlyWeatherWidget extends StatelessWidget {
  const HourlyWeatherWidget({super.key, required this.hourlyWeatherData});

  final WeatherData hourlyWeatherData;


  @override
  Widget build(BuildContext context) {
    return buildListView();
  }

  Widget buildListView() => SizedBox(
        height: 185,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: hourlyWeatherData.forecast.forecastday[0].hour.length,
          itemBuilder: (context, index) {

            int timeEpoch = hourlyWeatherData.forecast.forecastday[0].hour[index].timeEpoch;
            String time = DateFormat('Hm').format(DateTime.fromMillisecondsSinceEpoch(timeEpoch * 1000));
            int? tempC = (hourlyWeatherData.forecast.forecastday[0].hour[index].tempC)!.toInt();
            int humidity = hourlyWeatherData.forecast.forecastday[0].hour[index].humidity;
            String imageUrl = hourlyWeatherData.forecast.forecastday[0].hour[index].condition.icon;

            return buildHourlyWeatherDataDetailsCard(
              time: time,
              temp: tempC,
              imageUrl: imageUrl,
              humidity: humidity,
            );
          },
        ),
      );

  Widget buildHourlyWeatherDataDetailsCard({
    required String time,
    required int temp,
    required String imageUrl,
    required int humidity,
  }) =>
      Card(
        color: cardOnLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              time == '${DateTime.now().hour}:00' ? const Text('Now', style: TextStyle(fontSize: 16),) : Text(time, style: const TextStyle(fontSize: 16),),
              const SizedBox(height: 5,),
              Image.network('https:$imageUrl', width: 50, height: 50,),
              const SizedBox(height: 5,),
              Text(
                '$temp\u00B0',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/humidity_icon.png',
                    color: eveningColor,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text('$humidity%'),
                ],
              ),
            ],
          ),
        ),
      );
}
