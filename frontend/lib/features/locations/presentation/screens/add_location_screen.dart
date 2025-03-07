import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';
import 'package:weather_app/features/weather/presentation/screens/home_screen.dart';
import '../bloc/locations_bloc.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final controller = TextEditingController();

  late String locationName;
  late String country;
  late double latitude;
  late double longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: buildAppBar(context: context),
      body: buildBody(context: context),
    );
  }

  AppBar buildAppBar({required BuildContext context}) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Add Location',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        TextButton(
          onPressed: () {
            BlocProvider.of<LocationsBloc>(context).add(
              AddFavoriteLocationEvent(
                favoriteLocation: FavoriteLocationEntity(
                  locationName: locationName,
                  country: country,
                  latitude: latitude,
                  longitude: longitude,
                ),
              ),
            );
          },
          child: Row(
            children: [
              Text(
                'Save',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                Icons.check,
                size: 25,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBody({required BuildContext context}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 12,
            right: 12,
          ),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Search for a place...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isEmpty) return;
                  BlocProvider.of<LocationsBloc>(context)
                      .add(FetchLocationsSuggestionsEvent(locationName: value));
                },
              ),
              Expanded(
                child: buildLocationsBloc(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLocationsBloc() {
    return BlocConsumer<LocationsBloc, LocationsState>(
      listener: (context, state) {
        if (state.locationStatus == LocationStatus.favoriteLocationAdded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
        if (state.locationStatus == LocationStatus.addFavoriteLocationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(state.errorMessage!),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.locationStatus == LocationStatus.locationSuggestionsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.locationStatus == LocationStatus.locationSuggestionsLoaded) {
          return ListView.builder(
            itemCount: state.locationSuggestions?.features.length,
            itemBuilder: (context, index) {
              final location = state.locationSuggestions?.features[index];
              return ListTile(
                title: Text(location!.properties.formatted),
                onTap: () {
                  controller.text = location.properties.formatted;
                  locationName = location.properties.locationName;
                  country = location.properties.country;
                  latitude = location.properties.latitude;
                  longitude = location.properties.longitude;
                },
              );
            },
          );
        }
        if (state.locationStatus ==
            LocationStatus.fetchLocationSuggestionsError) {
          return Center(
            child: Text(
              state.errorMessage!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
