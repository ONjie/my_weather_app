import '../../Data Provider/Api/weather_api.dart';
import '../../Models/favorite_locations_weather_data_model.dart';
import '../../Models/weather_data_model.dart';

class WeatherApiRepository {

  final WeatherApi weatherApi = WeatherApi();

  Future<WeatherData> getWeatherData(
      {required double lat, required double long}) async {
    var data = await weatherApi.getWeatherData(lat: lat, long: long);
    return data;
  }

  Future<List<FavoriteLocationsWeatherData>> getFavoriteLocationsWeatherData() async {

    var favoriteLocationsWeatherData = await weatherApi.getFavoriteLocationsWeatherData();

    return favoriteLocationsWeatherData;
  }

}