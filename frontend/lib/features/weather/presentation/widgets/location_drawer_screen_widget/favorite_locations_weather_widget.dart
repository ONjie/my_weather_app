import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/urls/urls.dart';

import '../../../domain/entities/location_current_weather_entity.dart';

class FavoriteLocationsWeatherWidget extends StatelessWidget {
  const FavoriteLocationsWeatherWidget({
    super.key,
    required this.locationsCurrentWeather,
    this.errorMessage,
  });

  final List<LocationCurrentWeatherEntity> locationsCurrentWeather;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return locationsCurrentWeather.isEmpty
        ? buildErrorMessageWiget(
            context: context,
            errorMessage: errorMessage!,
          )
        : buildFavoriteLocationsListView(
            context: context,
            favoritelocationsCurrentWeather: locationsCurrentWeather,
          );
  }

  Widget buildErrorMessageWiget({
    required BuildContext context,
    required String errorMessage,
  }) {
    return Text(
      errorMessage,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget buildFavoriteLocationsListView({
    required BuildContext context,
    required List<LocationCurrentWeatherEntity> favoritelocationsCurrentWeather,
  }) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: favoritelocationsCurrentWeather.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              30,
              0,
              16,
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.circle_filled,
                        color: Theme.of(context).colorScheme.primary,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        favoritelocationsCurrentWeather[index].locationName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Image.network(
                        '$openWeatherMapIconUrl${favoritelocationsCurrentWeather[index].current.weather[0].icon}.png',
                        width: 50,
                      ),
                      Text(
                        '${favoritelocationsCurrentWeather[index].current.temp.toInt()}\u00B0',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
