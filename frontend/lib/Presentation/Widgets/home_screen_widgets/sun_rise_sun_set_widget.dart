import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Data/Models/weather_data_model.dart';
import '../../Constants/colors.dart';




class SunRiseSunSetWidget extends StatelessWidget {
  const SunRiseSunSetWidget({super.key, required this.astronomyData});

  final WeatherData astronomyData;

  @override
  Widget build(BuildContext context) {
    return buildCard();
  }

  Widget buildCard() {
    final String sunRise = ('${astronomyData.forecast.forecastday[0].date} ${astronomyData.forecast.forecastday[0].astro.sunrise.replaceAll('AM', ':00 ').replaceAll(' ', '')}');
    final String sunSet = ('${astronomyData.forecast.forecastday[0].date} ${astronomyData.forecast.forecastday[0].astro.sunset.replaceAll('PM', ':00 ').replaceAll(' ', '')}');
    
    String sunRiseTime = DateFormat('Hm').format(DateTime.parse(sunRise));
    String sunSetTime = DateFormat('Hm').format(DateTime.parse(sunSet));

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: cardOnLightColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('Sunrise', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                const SizedBox(width: 12,),
                Image.asset('assets/images/113.png', width: 35,),
                const SizedBox(height: 5,),
                Text(sunRiseTime, style: const TextStyle(fontSize: 14,),),
              ],
            ),
            Row(
              children: [
                const Text('Sunset', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                const SizedBox(width: 12,),
                Image.asset('assets/images/moon2.png', width: 19,color: nightColor,),
                const SizedBox(height: 5,),
                Text(sunSetTime, style: const TextStyle(fontSize: 14,),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
