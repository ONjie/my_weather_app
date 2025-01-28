import 'package:weather_app/Data/Data%20Provider/Database/favorite_locations_database.dart';

import '../../Models/favorite_locations_model.dart';

class DatabaseRepository{

  final FavoriteLocationsDatabase _favoriteLocationsDatabase = FavoriteLocationsDatabase.instance;

  Future<void> addFavoriteLocation(FavoriteLocation location) async{
    await _favoriteLocationsDatabase.addFavoriteLocation(location);
  }

  Future<List<FavoriteLocation>> getAllFavoriteLocations() async{
    final favoriteLocations = await _favoriteLocationsDatabase.getAllFavoriteLocations();
    return favoriteLocations;
  }

  Future<void> deleteFavoriteLocation(int id) async{
     await _favoriteLocationsDatabase.deleteFavoriteLocation(id);
  }

}