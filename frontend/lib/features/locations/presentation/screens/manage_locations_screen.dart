import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/utils/common_widgets/error_state_widget.dart';
import 'package:weather_app/core/utils/common_widgets/loading_widget.dart';
import 'package:weather_app/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:weather_app/features/locations/presentation/widgets/manage_locations_screen_widgets/display_favorite_locations.dart';

import '../../../weather/presentation/screens/home_screen.dart';

class ManageLocationsScreen extends StatefulWidget {
  const ManageLocationsScreen({super.key});

  @override
  State<ManageLocationsScreen> createState() => _ManageLocationsScreenState();
}

class _ManageLocationsScreenState extends State<ManageLocationsScreen> {
  @override
  void initState() {
    BlocProvider.of<LocationsBloc>(context).add(FetchFavoriteLocationsEvent());
    super.initState();
  }

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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),
          ));
        },
      ),
      title: Text(
        'Manage Locations',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget buildBody({required BuildContext context}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<LocationsBloc, LocationsState>(
      builder: (context, state) {
        if (state.locationStatus == LocationStatus.favoriteLocationsLoading) {
          return const LoadingWidget();
        }
        if (state.locationStatus == LocationStatus.favoriteLocationsLoaded) {
          return SafeArea(
            child: SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favorite Locations',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DisplayFavoriteLocations(
                        favoriteLocations: state.favoriteLocations!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state.locationStatus ==
            LocationStatus.fetchFavoriteLocationsError) {
          return ErrorStateWidget(
            errorMessage: state.errorMessage!,
            onPressed: () {
              BlocProvider.of<LocationsBloc>(context)
                  .add(FetchFavoriteLocationsEvent());
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
