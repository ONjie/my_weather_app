import 'package:dart_frog/dart_frog.dart';
import 'package:dio/dio.dart';
import 'package:my_weather_api/src/weather_api/datasources/remote_data_sources/weather_api.dart';
import 'package:my_weather_api/src/weather_api/repositories/weather_api_repository.dart';

final _weatherApiImpl = WeatherApiImpl(dio: Dio());

final weatherApiRepositoryImpl =
    WeatherApiRepositoryImpl(weatherApi: _weatherApiImpl);

Handler middleware(Handler handler) {
  return handler
      .use(provider<WeatherApiRepository>((_) => weatherApiRepositoryImpl))
      .use(provider<WeatherApi>((_) => _weatherApiImpl));
}
