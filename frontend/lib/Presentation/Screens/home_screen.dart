import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Presentation/Widgets/home_screen_widgets/locations_drawer_widget.dart';

import '../../BLoC/Weather Bloc/weather_bloc.dart';
import '../../BLoC/Weather Bloc/weather_event.dart';
import '../../BLoC/Weather Bloc/weather_state.dart';
import '../../Data/Models/favorite_locations_weather_data_model.dart';
import '../../Data/Models/weather_data_model.dart';
import '../Constants/colors.dart';
import '../Widgets/home_screen_widgets/daily_weather_widget.dart';
import '../Widgets/home_screen_widgets/favorite_locations_weather_widget.dart';
import '../Widgets/home_screen_widgets/hourly_weather_widget.dart';
import '../Widgets/home_screen_widgets/sun_rise_sun_set_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    BlocProvider.of<WeatherBloc>(context).add(OnGetWeatherDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherDataLoadingState) {
            return Container(
              color: cardOnLightColor,
              child: Center(
                child: Image.asset(
                  'assets/icons/weather_app_logo.png',
                  width: 130,
                ),
              ),
            );
          }
          if (state is WeatherDataLoadedState) {
            return Scaffold(
              drawerEnableOpenDragGesture: false,
              drawer: LocationsDrawerWidget(
                favoriteLocationsWeatherData:
                    state.favoriteLocationsWeatherData,
              ),
              backgroundColor: lightBackgroundColor,
              appBar: buildAppBar(
                context: context,
                weatherData: state.weatherData,
              ),
              body: buildBody(
                context: context,
                weatherData: state.weatherData,
                favoriteLocationsWeatherData:
                    state.favoriteLocationsWeatherData,
              ),
            );
          }
          if (state is WeatherDataErrorState) {
            return Container(
              color: lightBackgroundColor,
              child: Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: CupertinoColors.black,
                  ),
                ),
              ),
            );
          }
          return Container(
            color: lightBackgroundColor,
            child: const Center(
              child: Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: CupertinoColors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar buildAppBar({required BuildContext context, required WeatherData weatherData}) {
    var date = weatherData.forecast.forecastday[0].date;

    String today = DateFormat('EEEE d, MMMM').format(DateTime.parse(date));

    return AppBar(
      backgroundColor: lightBackgroundColor,
      automaticallyImplyLeading: false,
      leading: Builder(builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      centerTitle: true,
      title: Text(
        today,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.black,
        ),
      ),
    );
  }

  Widget buildBody({
    required BuildContext context,
    required WeatherData weatherData,
    required List<FavoriteLocationsWeatherData> favoriteLocationsWeatherData,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
            child: Column(
              children: [
                FavoriteLocationsWeatherWidget(
                  favoriteLocationsWeatherData: favoriteLocationsWeatherData,
                ),
                const SizedBox(
                  height: 12,
                ),
                HourlyWeatherWidget(
                  hourlyWeatherData: weatherData,
                ),
                const SizedBox(
                  height: 12,
                ),
                SunRiseSunSetWidget(
                  astronomyData: weatherData,
                ),
                const SizedBox(
                  height: 12,
                ),
                DailyWeatherWidget(
                  dailyWeatherData: weatherData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
