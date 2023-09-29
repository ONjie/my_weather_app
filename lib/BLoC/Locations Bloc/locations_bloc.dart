import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/Data/Data%20Repository/Database%20Repository/database_repository.dart';
import 'package:weather_app/Data/Data%20Repository/Location%20Repository/location_repository.dart';
import 'package:weather_app/Data/Models/favorite_locations_model.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc() : super(LocationsInitial()) {
    on<OnGetFavoriteLocationsEvent>(_onGetFavoriteLocations);
    on<OnAddFavoriteLocationEvent>(_onAddFavoriteLocation);
    on<OnDeleteLocationEvent>(_onDeleteLocation);
  }

 final DatabaseRepository _databaseRepository = DatabaseRepository();
 final LocationRepository locationRepository = LocationRepository();

  _onGetFavoriteLocations(OnGetFavoriteLocationsEvent event, Emitter<LocationsState> emit) async {
    late List<FavoriteLocation> favoriteLocations = [];
    try{
       emit(FavoriteLocationsLoadingState());

       var location = await locationRepository.getDeviceLocation();
       favoriteLocations = await _databaseRepository.getAllFavoriteLocations();

       if(favoriteLocations.isNotEmpty){
         emit(FavoriteLocationsLoadedState(favoriteLocations: favoriteLocations, location: location));
       }
       else{
         emit(const FetchFavoriteLocationsErrorState(errorMessage: 'No favorite locations yet!'));
       }

    }catch(e){
      emit(const FetchFavoriteLocationsErrorState(errorMessage: 'Unable to fetch favorite locations'));
      e.toString();
    }
  }

  _onAddFavoriteLocation(OnAddFavoriteLocationEvent event, Emitter<LocationsState> emit) async {
   try{
     await _databaseRepository.addFavoriteLocation(FavoriteLocation(
         locationName: event.locationName,
         latitude: event.latitude,
         longitude: event.longitude,
       ),);

     emit(const FavoriteLocationAddedState(message: 'Successfully added to favorite locations'));
   }
   catch(e){
     e.toString();
   }

  }

  _onDeleteLocation(OnDeleteLocationEvent event, Emitter<LocationsState> emit) async {
    try{
      await _databaseRepository.deleteFavoriteLocation(event.id);
    }
    catch(e){
      e.toString();
    }
  }


}
