import 'package:bloc/bloc.dart';
import 'package:weather_app/BLoC/Weather%20Bloc/weather_event.dart';
import 'package:weather_app/BLoC/Weather%20Bloc/weather_state.dart';
import 'package:weather_app/Data/Data%20Repository/Database%20Repository/database_repository.dart';
import 'package:weather_app/Data/Data%20Repository/Location%20Repository/location_repository.dart';

import '../../Data/Data Repository/Api Repository/weather_api_repository.dart';


class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super( WeatherDataLoadingState()) {
   on<OnGetWeatherDataEvent>(_onGetWeatherData);
  }
  final WeatherApiRepository weatherApiRepository = WeatherApiRepository();
  final LocationRepository locationRepository = LocationRepository();
  final DatabaseRepository databaseRepository = DatabaseRepository();

  _onGetWeatherData(OnGetWeatherDataEvent event, Emitter<WeatherState> emit)async{
    try{

      var location = await locationRepository.getDeviceLocation();

      var weatherData = await weatherApiRepository.getWeatherData(lat: location.latitude, long: location.longitude);

     var favoriteLocationsWeatherData = await weatherApiRepository.getFavoriteLocationsWeatherData();

      emit(WeatherDataLoadedState(weatherData: weatherData, favoriteLocationsWeatherData: favoriteLocationsWeatherData),);

    }
    catch(e){
      emit(const WeatherDataErrorState(errorMessage: 'Unable to Fetch Weather Data'),);
      e.toString();
    }
  }
}
