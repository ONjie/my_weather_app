import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/BLoC/Weather%20Bloc/weather_bloc.dart';

import 'BLoC/Locations Bloc/locations_bloc.dart';
import 'Presentation/Screens/home_screen.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherBloc>(create: (context) => WeatherBloc(),),
        BlocProvider<LocationsBloc>(create: (context) => LocationsBloc(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: CupertinoColors.white),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

