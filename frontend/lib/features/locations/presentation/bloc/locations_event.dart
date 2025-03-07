part of 'locations_bloc.dart';

sealed class LocationsEvent extends Equatable {
  const LocationsEvent();
}

class AddFavoriteLocationEvent extends LocationsEvent {
  final FavoriteLocationEntity favoriteLocation;

  const AddFavoriteLocationEvent({
    required this.favoriteLocation,
  });

  @override
  List<Object?> get props => [favoriteLocation];
}

class FetchFavoriteLocationsEvent extends LocationsEvent {
  @override
  List<Object?> get props => [];
}

class DeleteFavoriteLocationEvent extends LocationsEvent {
  final int id;

  const DeleteFavoriteLocationEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class FetchLocationsSuggestionsEvent extends LocationsEvent {
  final String locationName;

  const FetchLocationsSuggestionsEvent({required this.locationName});

  @override
  List<Object?> get props => [locationName];
}
