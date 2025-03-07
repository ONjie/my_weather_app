import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/presentation/widgets/location_drawer_screen_widget/favorite_locations_weather_widget.dart';
import 'package:weather_app/features/weather/presentation/widgets/location_drawer_screen_widget/navigate_to_screen_widget.dart';
import '../../../locations/presentation/screens/add_location_screen.dart';
import '../../../locations/presentation/screens/manage_locations_screen.dart';
import '../../domain/entities/location_current_weather_entity.dart';

class LocationsDrawerScreen extends StatelessWidget {
  const LocationsDrawerScreen({
    super.key,
    required this.locationsCurrentWeather,
    this.errorMessage,
  });

  final List<LocationCurrentWeatherEntity> locationsCurrentWeather;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor:
          Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
      child: SafeArea(
          child: SizedBox(
        height: screenHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 12,
            right: 12,
          ),
          child: Column(
            children: [
              buildFavoriteLocationsLabel(context: context),
              const SizedBox(
                height: 20,
              ),
              FavoriteLocationsWeatherWidget(
                locationsCurrentWeather: locationsCurrentWeather,
                errorMessage: errorMessage,
              ),
              const SizedBox(
                height: 20,
              ),
              NavigateToScreenWidget(
                title: 'Add location',
                icon: Icons.location_on_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddLocationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              NavigateToScreenWidget(
                title: 'Manage locations',
                icon: Icons.tune,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageLocationsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget buildFavoriteLocationsLabel({required BuildContext context}) {
    return Row(
      children: [
        Icon(
          CupertinoIcons.star_fill,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          'Favorite Locations',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
