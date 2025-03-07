import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/time_converters/local_time_converter.dart';
import 'package:weather_app/core/utils/urls/urls.dart';

import '../../../domain/entities/location_current_weather_entity.dart';

class FavoriteLocationsWeatherCardWidget extends StatefulWidget {
  const FavoriteLocationsWeatherCardWidget({
    super.key,
    required this.locationsCurrentWeather,
    this.errorMessage,
  });

  final List<LocationCurrentWeatherEntity> locationsCurrentWeather;
  final String? errorMessage;

  @override
  State<FavoriteLocationsWeatherCardWidget> createState() =>
      _FavoriteLocationsWeatherCardWidgetState();
}

class _FavoriteLocationsWeatherCardWidgetState
    extends State<FavoriteLocationsWeatherCardWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: double.infinity,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: widget.locationsCurrentWeather.isEmpty
              ? buildErrorMessageWiget(errorMessage: widget.errorMessage!)
              : buildLocationsWeatherCarousel(),
        ),
      ),
    );
  }

  Widget buildErrorMessageWiget({
    required String errorMessage,
  }) {
    return Center(
      child: Text(
        errorMessage,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget buildLocationsWeatherCarousel() {
    return Column(
      children: [
        CarouselSlider(
          items: widget.locationsCurrentWeather.map((e) {
            return builDisplayLocationsWeatherDetails(
              locationName: e.locationName,
              localTime: localTimeConverter(
                timestamp: e.current.dateTimestamp,
                timezoneOffset: e.timezoneOffset,
              ),
              temperature: e.current.temp,
              weatherIcon: e.current.weather[0].icon,
            );
          }).toList(),
          options: CarouselOptions(
            viewportFraction: 1,
            aspectRatio: 2.0,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) => setState(
              () => currentIndex = index,
            ),
          ),
        ),
        DotsIndicator(
          dotsCount: widget.locationsCurrentWeather.length,
          position: currentIndex,
          decorator: DotsDecorator(
            color: Colors.grey,
            activeColor: Theme.of(context).colorScheme.tertiary,
          ),
        )
      ],
    );
  }

  Widget builDisplayLocationsWeatherDetails({
    required String locationName,
    required String localTime,
    required double temperature,
    required String weatherIcon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localTime,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              '$temperature\u00B0',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              locationName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              '$openWeatherMapIconUrl$weatherIcon.png',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ],
        )
      ],
    );
  }
}
