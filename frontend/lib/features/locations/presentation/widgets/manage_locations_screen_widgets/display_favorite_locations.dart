import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';

import '../../bloc/locations_bloc.dart';

class DisplayFavoriteLocations extends StatelessWidget {
  const DisplayFavoriteLocations({super.key, required this.favoriteLocations});

  final List<FavoriteLocationEntity> favoriteLocations;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: favoriteLocations.length,
      itemBuilder: (context, index) {
        final favoriteLocation = favoriteLocations[index];

        return buildFavoriteLocationCard(
          favoriteLocation: favoriteLocation,
          context: context,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
    );
  }

  Widget buildFavoriteLocationCard({
    required FavoriteLocationEntity favoriteLocation,
    required BuildContext context,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${favoriteLocation.locationName}, ${favoriteLocation.country}',),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                BlocProvider.of<LocationsBloc>(context).add(DeleteFavoriteLocationEvent(id: favoriteLocation.id!));
                BlocProvider.of<LocationsBloc>(context).add(FetchFavoriteLocationsEvent());
              },
            ),
        
          ],
        ),
      ),
    );
  }
}
