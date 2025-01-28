
class FavoriteLocationsWeatherData {
 late final  String locationName;
  late final int localtimeEpoch;
  late final String localtime;
  late final double tempC;
   late final String icon;
   late final String countryName;

  FavoriteLocationsWeatherData({
    required this.locationName,
    required this.localtimeEpoch,
    required this.localtime,
    required this.tempC,
    required this.icon,
    required this.countryName
  });


 FavoriteLocationsWeatherData.fromJson(Map<String, dynamic> json){
   locationName = json['location']['name'];
   countryName = json['location']['country'];
   localtimeEpoch = json['location']['localtime_epoch'];
   localtime = json['location']['localtime'];
   tempC = json['current']['temp_c'];
   icon = json['current']['condition']['icon'];
 }

}



