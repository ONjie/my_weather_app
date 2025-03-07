import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
   @EnviedField(varName: 'OPEN_WEATHER_MAP_API_KEY')
  static String openWeatherMapApiKey = _Env.openWeatherMapApiKey;

  @EnviedField(varName: 'GEOAPIFY_API_KEY')
  static String geoapifyApiKey = _Env.geoapifyApiKey; 
}




