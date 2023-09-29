import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/Data/Models/favorite_locations_weather_data_model.dart';
import 'package:weather_app/Data/Models/weather_data_model.dart';
import 'package:weather_app/Presentation/Constants/text.dart';

import '../../Data Repository/Database Repository/database_repository.dart';


class WeatherApi{

  final DatabaseRepository databaseRepository = DatabaseRepository();

  Future<WeatherData> getWeatherData({required double lat, required double long}) async {
    var url = 'https://api.weatherapi.com/v1/forecast.json?key=$weatherApiKey&q=$lat,$long&days=7';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
   var data = json.decode(response.body);
    return WeatherData.fromJson(data);
  }

  Future<List<FavoriteLocationsWeatherData>> getFavoriteLocationsWeatherData() async {
  late List<FavoriteLocationsWeatherData> favoriteLocationsWeatherData = [];
   var favoriteLocations = await databaseRepository.getAllFavoriteLocations();

   for(var favoriteLocation in favoriteLocations){

     var url = 'https://api.weatherapi.com/v1/current.json?key=$weatherApiKey&q=${favoriteLocation.latitude},${favoriteLocation.longitude}&days=7';
     var uri = Uri.parse(url);
     var response = await http.get(uri);
     var  data = json.decode(response.body);

    favoriteLocationsWeatherData.add(FavoriteLocationsWeatherData.fromJson(data));

   }

  return favoriteLocationsWeatherData;

  }
}

