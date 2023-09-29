import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Data/Models/favorite_locations_weather_data_model.dart';
import 'package:weather_app/Presentation/Constants/colors.dart';


class FavoriteLocationsWeatherWidget extends StatefulWidget {
   const FavoriteLocationsWeatherWidget({super.key, required this.favoriteLocationsWeatherData});

 final List<FavoriteLocationsWeatherData> favoriteLocationsWeatherData;



  @override
  State<FavoriteLocationsWeatherWidget> createState() => _FavoriteLocationsWeatherWidgetState();
}

class _FavoriteLocationsWeatherWidgetState extends State<FavoriteLocationsWeatherWidget> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.favoriteLocationsWeatherData.isEmpty ? buildEmptyFavoriteLocationsWeatherDataDetailsCard() : buildCard();
  }

  Widget buildCard(){
    return Card(
      color: cardOnLightColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            buildCarouselSlider(),
            buildDotsIndicator()
          ],
        ),
      ),
    );
  }

  Widget buildCarouselSlider() => CarouselSlider(
    items: widget.favoriteLocationsWeatherData.map((e) {

      String localTime = DateFormat('EE, H:mm').format(DateTime.parse(e.localtime));

      return buildFavoriteLocationsWeatherDataDetailsCard(
        location: e.locationName,
        temp: (e.tempC).toInt(),
        dateTime: localTime,
        imageUrl: e.icon,
      );
    }
    ).toList(),
    options: CarouselOptions(
      viewportFraction: 1,
      autoPlay: true,
      enlargeCenterPage: true,
      aspectRatio: 2.0,
      onPageChanged: (index, reason) => setState(() => currentIndex = index),
    ),
  );

  Widget buildFavoriteLocationsWeatherDataDetailsCard({
    required String location,
   required int temp,
   required String dateTime,
   required String imageUrl,}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateTime, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            const SizedBox(height: 12,),
            Text('$temp\u00B0', style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w500),),
            const SizedBox(height: 12,),
            Text(location, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
          ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network('http:$imageUrl', height: 100, width: 100, fit: BoxFit.cover,),
        ],
      ),
    ],
  );

  Widget buildEmptyFavoriteLocationsWeatherDataDetailsCard() => const SizedBox(
    width: double.infinity,
    height: 200,
    child: Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Favorite Locations yet!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
          ],
        ),
      ),
    ),
  );


  Widget buildDotsIndicator() => DotsIndicator(
    decorator: DotsDecorator(
      color: Colors.grey,
      activeColor: nightColor,
    ),
    dotsCount: widget.favoriteLocationsWeatherData.length,
    position: currentIndex,
  );
}
