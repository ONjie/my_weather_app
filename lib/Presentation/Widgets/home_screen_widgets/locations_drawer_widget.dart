import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/Presentation/Constants/colors.dart';
import 'package:weather_app/Presentation/Screens/add_favorite_location_screen.dart';
import 'package:weather_app/Presentation/Screens/manage_locations_screen.dart';

import '../../../Data/Models/favorite_locations_weather_data_model.dart';

class LocationsDrawerWidget extends StatelessWidget {
  const LocationsDrawerWidget({super.key, required this.favoriteLocationsWeatherData});

  final List<FavoriteLocationsWeatherData> favoriteLocationsWeatherData;


  @override
  Widget build(BuildContext context) {
    return buildLocationsDrawer(context: context);
  }

  Widget buildLocationsDrawer({required BuildContext context}) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Drawer(
      backgroundColor: lightBackgroundColor.withOpacity(0.8),
      child: SafeArea(
        child: SizedBox(
          height: screenHeight,
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 12, right: 12),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                const Row(
                  children: [
                    Icon(CupertinoIcons.star_fill, color: CupertinoColors.black,),
                    SizedBox(width: 10,),
                    Text('Favorite Locations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                  ],
                ),
                const SizedBox(height: 20,),
               favoriteLocationsWeatherData.isEmpty ? buildNoFavoriteLocationsContainer() : buildFavoriteLocationsListView(),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFavoriteLocationScreen(),),);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                      Icon(Icons.location_on_outlined)
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageLocationsScreen(),),);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Manage locations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                      Icon(Icons.tune)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNoFavoriteLocationsContainer() => const Center(
    child: Text('No Favorite Locations yet!',
      style: TextStyle(
        backgroundColor: Colors.transparent,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: CupertinoColors.black,
      ),
    ),
  );

 Widget buildFavoriteLocationsListView() => ListView.builder(
     shrinkWrap: true,
     scrollDirection: Axis.vertical,
     itemCount: favoriteLocationsWeatherData.length,
     itemBuilder: (context, index){
       return Padding(
         padding: const EdgeInsets.only(left: 30, right: 16, bottom: 8),
         child: buildFavoriteLocationsListViewItems(
             location: favoriteLocationsWeatherData[index].locationName,
             imageUrl: favoriteLocationsWeatherData[index].icon,
             temp: (favoriteLocationsWeatherData[index].tempC).toInt(),
         ),
       );
     }
 );

 Widget buildFavoriteLocationsListViewItems({required String location, required String imageUrl, required int temp}) => Row(
   mainAxisAlignment: MainAxisAlignment.spaceBetween,
   children: [
     SizedBox(
       child: Row(
         children: [
           Image.asset('assets/images/more.png', width: 15,),
           const SizedBox(width: 8,),
           Text(location, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
         ],
       ),
     ),
     SizedBox(
       child: Row(
         children: [
           Image.network('http:$imageUrl', width: 30,),
           Text('$temp\u00B0', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
         ],
       ),
     ),
   ],
 );
}
