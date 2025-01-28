import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:weather_app/BLoC/Locations%20Bloc/locations_bloc.dart';
import 'package:weather_app/Presentation/Constants/colors.dart';

import '../Constants/text.dart';
import 'home_screen.dart';

class AddFavoriteLocationScreen extends StatefulWidget {
  const AddFavoriteLocationScreen({super.key});

  @override
  State<AddFavoriteLocationScreen> createState() => _AddFavoriteLocationScreenState();
}

class _AddFavoriteLocationScreenState extends State<AddFavoriteLocationScreen> {
  TextEditingController controller = TextEditingController();

  late String locationName;
  late double latitude;
  late double longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: buildAppBar(),
      body: buildBody(context: context),
    );
  }

  AppBar buildAppBar() => AppBar(
        backgroundColor: lightBackgroundColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: CupertinoColors.black,
            ),),
        elevation: 0,
        title: const Text(
          'Add Location',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              BlocProvider.of<LocationsBloc>(context).add(OnAddFavoriteLocationEvent(locationName: locationName, latitude: latitude, longitude: longitude));
               Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            child: const Row(
              children: [
                Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.done_rounded,
                  color: CupertinoColors.activeBlue,
                )
              ],
            ),
          )
        ],
      );

  Widget buildBody({required BuildContext context}) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 12, right: 12,),
          child: Column(
            children: [
              placesAutoCompleteTextField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget placesAutoCompleteTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CupertinoColors.white,
      ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: googlePlacesApiKey,
        inputDecoration: const InputDecoration(
          filled: true,
          fillColor: CupertinoColors.white,
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries:const [],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          locationName = prediction.description!;
          latitude = double.parse(prediction.lat!);
          longitude = double.parse(prediction.lng!);
        },

        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
        },
        seperatedBuilder: const Divider(color: CupertinoColors.black,),
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            color: CupertinoColors.white,
            padding: const EdgeInsets.all(10),
            child: Text(prediction.description??""),
          );
        },
        isCrossBtnShown: true,
      ),
    );
  }
}
