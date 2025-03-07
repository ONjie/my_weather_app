import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/utils/theme/theme.dart';
import 'package:weather_app/core/utils/theme/bloc/theme_state.dart';
import 'core/utils/theme/bloc/theme_bloc.dart';
import 'features/locations/presentation/bloc/locations_bloc.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';
import 'features/weather/presentation/screens/home_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.locator<WeatherBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<LocationsBloc>(),
        ),
        BlocProvider(create: (context) => di.locator<ThemeBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: lightMode,
          darkTheme: darkMode,
          themeMode: state.themeMode ,
          home: const HomeScreen(),
        );
      }),
    );
  }
}
