part of 'locations_bloc.dart';

abstract class LocationsState extends Equatable {
  const LocationsState();
}

class LocationsInitial extends LocationsState {
  @override
  List<Object> get props => [];
}

class FavoriteLocationsLoadingState extends LocationsState{
  @override
  List<Object?> get props => [];
}

class FavoriteLocationsLoadedState extends LocationsState{
  final List<FavoriteLocation> favoriteLocations;
  final Position location;

  const FavoriteLocationsLoadedState({required this.favoriteLocations, required this.location});

  @override
  List<Object?> get props => [favoriteLocations, location];
}

class FetchFavoriteLocationsErrorState extends LocationsState{
  final String errorMessage;

  const FetchFavoriteLocationsErrorState({required this.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];


}

class FavoriteLocationAddedState extends LocationsState{
  final String message;

  const FavoriteLocationAddedState({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
