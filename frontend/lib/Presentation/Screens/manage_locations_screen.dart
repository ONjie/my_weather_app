import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/BLoC/Locations%20Bloc/locations_bloc.dart';
import 'package:weather_app/Presentation/Constants/colors.dart';
import 'package:weather_app/Presentation/Widgets/manage_locations_screen_widgets/favorite_locations_list_widget.dart';

import 'home_screen.dart';


class ManageLocationsScreen extends StatefulWidget {
  const ManageLocationsScreen({super.key,});

  @override
  State<ManageLocationsScreen> createState() => _ManageLocationsScreenState();
}

class _ManageLocationsScreenState extends State<ManageLocationsScreen> {

  @override
  void initState() {
   BlocProvider.of<LocationsBloc>(context).add(OnGetFavoriteLocationsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: buildAppBar(),
      body: buildBody(context: context),
    );
  }

  AppBar buildAppBar() => AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: lightBackgroundColor,
        title: const Text(
          'Manage Locations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
    leading: IconButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
      icon: const Icon(
        Icons.arrow_back,
        color: CupertinoColors.black,
      ),
    ),
      );

  Widget buildBody({required BuildContext context}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<LocationsBloc, LocationsState>(
      builder: (context, state) {
        if(state is FavoriteLocationsLoadingState){
          return Container(
            color: lightBackgroundColor,
            child: Center(
              child: CircularProgressIndicator(color: Colors.grey[500],),
            ),
          );
        }
        if(state is FavoriteLocationsLoadedState){
          return SafeArea(
            child: SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favorite Locations',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16,),
                      FavoriteLocationsListWidget(favoriteLocations: state.favoriteLocations),
                      const SizedBox(height: 30,),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if(state is FetchFavoriteLocationsErrorState){
          return Container(
            color: lightBackgroundColor,
            child: Center(
              child: Text(state.errorMessage, style: const TextStyle(fontSize: 20, color: CupertinoColors.black),)
            ),
          );
        }
        return Container();
      },
    );
  }


}
