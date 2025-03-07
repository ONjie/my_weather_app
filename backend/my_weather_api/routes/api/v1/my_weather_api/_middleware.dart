import 'package:dart_frog/dart_frog.dart';
import 'package:dio/dio.dart';
import 'package:my_weather_api/src/my_weather_api/data_sources/remote_data_source/open_weather_map_api.dart';
import 'package:my_weather_api/src/my_weather_api/repositories/my_weather_api_repository.dart';

final _openWeatherMapApiImpl = OpenWeatherMapApiImpl(dio: Dio());
final _myWeatherApiRepositoryImpl = MyWeatherApiRepositoryImpl(
  openWeatherMapApi: _openWeatherMapApiImpl,
);

Handler middleware(Handler handler) {
  return handler
      .use(
        provider<MyWeatherApiRepository>(
          (_) => _myWeatherApiRepositoryImpl,
        ),
      )
      .use(
        provider<OpenWeatherMapApi>(
          (_) => _openWeatherMapApiImpl,
        ),
      );
}
