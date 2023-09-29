import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/Data/Models/favorite_locations_model.dart';

import '../../../BLoC/Locations Bloc/locations_bloc.dart';

class FavoriteLocationsListWidget extends StatelessWidget {
  const FavoriteLocationsListWidget({super.key, required this.favoriteLocations,});

  final List<FavoriteLocation> favoriteLocations;

  @override
  Widget build(BuildContext context) {
    return buildFavoriteLocationsListViewBuilder(context: context);
  }

  Widget buildFavoriteLocationsListViewBuilder({required BuildContext context}) => ListView.builder(
    shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: favoriteLocations.length,
      itemBuilder: (context, index){
        return buildFavoriteLocationsListTile(
            locationName: favoriteLocations[index].locationName, 
            id: favoriteLocations[index].id!, context: context,
        );
      }
  );

  Widget buildFavoriteLocationsListTile({required String locationName, required int id, required BuildContext context}) => Card(
    elevation: 0,
    color: CupertinoColors.white,
    child: Padding(
        padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            locationName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.black,
            ),
          ),
          IconButton(
              onPressed: (){
                BlocProvider.of<LocationsBloc>(context).add(OnDeleteLocationEvent(id: id));
                BlocProvider.of<LocationsBloc>(context).add(OnGetFavoriteLocationsEvent());
              },
              icon: const Icon(CupertinoIcons.delete, color: CupertinoColors.black,)),
        ],
      ),
    ),
  );
}
