import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/failures/failures.dart';
import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';
import 'package:weather_app/features/locations/domain/use_cases/add_favorite_location.dart';
import 'package:weather_app/features/locations/domain/use_cases/delete_favorite_location.dart';
import 'package:weather_app/features/locations/domain/use_cases/fetch_favorite_locations.dart';
import 'package:weather_app/features/locations/domain/use_cases/fetch_locations_suggestions.dart';

import '../../domain/entities/location_entity.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final AddFavoriteLocation addFavoriteLocation;
  final FetchFavoriteLocations fetchFavoriteLocations;
  final DeleteFavoriteLocation deleteFavoriteLocation;
  final FetchLocationsSuggestions fetchLocationsSuggestions;
  LocationsBloc(
      {required this.addFavoriteLocation,
      required this.fetchFavoriteLocations,
      required this.deleteFavoriteLocation,
      required this.fetchLocationsSuggestions})
      : super(
          const LocationsState(
            locationStatus: LocationStatus.initial,
          ),
        ) {
    on<AddFavoriteLocationEvent>(_onAddFavoriteLocation);
    on<FetchFavoriteLocationsEvent>(_onFetchFavoriteLocations);
    on<DeleteFavoriteLocationEvent>(_onDeleteFavoriteLocation);
    on<FetchLocationsSuggestionsEvent>(_onFetchLocationsSuggestions);
  }

  _onAddFavoriteLocation(
      AddFavoriteLocationEvent event, Emitter<LocationsState> emit) async {
    final generatedIdOrFailure = await addFavoriteLocation.execute(
      favoriteLocation: event.favoriteLocation,
    );

    generatedIdOrFailure.fold(
      (failure) {
        emit(
          LocationsState(
            locationStatus: LocationStatus.addFavoriteLocationError,
            errorMessage: _mapFailureToMessage(
              failure: failure,
            ),
          ),
        );
      },
      (generatedId) {
        emit(
          const LocationsState(
            locationStatus: LocationStatus.favoriteLocationAdded,
          ),
        );
      },
    );
  }

  _onFetchFavoriteLocations(
      LocationsEvent event, Emitter<LocationsState> emit) async {
    emit(
      const LocationsState(
        locationStatus: LocationStatus.favoriteLocationsLoading,
      ),
    );

    final favoriteLocationsOrFailure = await fetchFavoriteLocations.execute();

    favoriteLocationsOrFailure.fold(
      (failure) {
        emit(
          LocationsState(
            locationStatus: LocationStatus.fetchFavoriteLocationsError,
            errorMessage: _mapFailureToMessage(failure: failure),
          ),
        );
      },
      (favoriteLocations) {
        emit(
          LocationsState(
            locationStatus: LocationStatus.favoriteLocationsLoaded,
            favoriteLocations: favoriteLocations,
          ),
        );
      },
    );
  }

  _onDeleteFavoriteLocation(
      DeleteFavoriteLocationEvent event, Emitter<LocationsState> emit) async {
    final isDeletedOrFailure = await deleteFavoriteLocation.execute(
      id: event.id,
    );

    isDeletedOrFailure.fold(
      (failure) {
        emit(
          LocationsState(
            locationStatus: LocationStatus.deleteFavoriteLocationError,
            errorMessage: _mapFailureToMessage(failure: failure),
          ),
        );
      },
      (isDeleted) {
        emit(
          const LocationsState(
            locationStatus: LocationStatus.favoriteLocationDeleted,
          ),
        );
      },
    );
  }

  _onFetchLocationsSuggestions(
    FetchLocationsSuggestionsEvent event,
    Emitter<LocationsState> emit,
  ) async {
    emit(
      const LocationsState(
        locationStatus: LocationStatus.locationSuggestionsLoading,
      ),
    );

    final locationSuggestionsOrFailure =
        await fetchLocationsSuggestions.execute(
      locationName: event.locationName,
    );

    locationSuggestionsOrFailure.fold(
      (failure) {
        emit(
          LocationsState(
            locationStatus: LocationStatus.fetchLocationSuggestionsError,
            errorMessage: _mapFailureToMessage(failure: failure),
          ),
        );
      },
      (locationSuggestions) {
        emit(
          LocationsState(
            locationStatus: LocationStatus.locationSuggestionsLoaded,
            locationSuggestions: locationSuggestions,
          ),
        );
      },
    );
  }
}

String _mapFailureToMessage({required Failure failure}) {
  if (failure is DatabaseFailure) {
    return failure.message;
  } else if (failure is OtherFailure) {
    return failure.message;
  } else if (failure is ServerFailure) {
    return failure.message;
  } else {
    return 'Unknown Error';
  }
}
