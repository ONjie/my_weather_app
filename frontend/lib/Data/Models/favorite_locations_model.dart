
const String tableName = 'favoriteLocations';

class FavoriteLocationFields {

  static final List<String> values = [
    id, locationName, latitude, longitude
  ];
  static const String id = '_id';
  static const String locationName = 'locationName';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
}


class FavoriteLocation{
  final int? id;
  final String locationName;
  final double latitude;
  final double longitude;

  FavoriteLocation({this.id, required this.locationName, required this.latitude, required this.longitude});


  FavoriteLocation copy({
    int? id,
    String? locationName,
    double? latitude,
    double? longitude
  }) => FavoriteLocation(
    id: id ?? this.id,
    locationName: locationName ?? this.locationName,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude
  );


  factory FavoriteLocation.fromJson(Map<String, dynamic> json){
    return FavoriteLocation(
      id: json[FavoriteLocationFields.id],
      locationName: json[FavoriteLocationFields.locationName],
      latitude: json[FavoriteLocationFields.latitude],
      longitude: json[FavoriteLocationFields.longitude],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      FavoriteLocationFields.id: id,
      FavoriteLocationFields.locationName: locationName,
      FavoriteLocationFields.latitude: latitude,
      FavoriteLocationFields.longitude: longitude
    };
  }
}