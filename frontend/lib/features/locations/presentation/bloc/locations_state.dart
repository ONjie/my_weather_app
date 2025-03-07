part of 'locations_bloc.dart';

enum LocationStatus {
  initial,
  favoriteLocationsLoading,
  favoriteLocationsLoaded,
  favoriteLocationAdded,
  favoriteLocationDeleted,
  addFavoriteLocationError,
  fetchFavoriteLocationsError,
  deleteFavoriteLocationError,
  locationSuggestionsLoading,
  locationSuggestionsLoaded,
  fetchLocationSuggestionsError,
}

class LocationsState extends Equatable {
  const LocationsState(
      {required this.locationStatus,
      this.favoriteLocations,
      this.locationSuggestions,
      this.errorMessage,
      this.successMessage,});

  final LocationStatus locationStatus;
  final List<FavoriteLocationEntity>? favoriteLocations;
  final LocationEntity? locationSuggestions;
  final String? errorMessage;
  final String? successMessage;

  @override
  List<Object?> get props => [
        locationStatus,
        favoriteLocations,
        locationSuggestions,
        errorMessage,
        successMessage,
      ];
}
