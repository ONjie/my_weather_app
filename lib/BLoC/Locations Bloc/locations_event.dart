part of 'locations_bloc.dart';

abstract class LocationsEvent extends Equatable {
  const LocationsEvent();
}

class OnAddFavoriteLocationEvent extends LocationsEvent{
  final String locationName;
  final double latitude;
  final double longitude;

  const OnAddFavoriteLocationEvent({required this.locationName, required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [locationName, latitude, longitude];
}

class OnGetFavoriteLocationsEvent extends LocationsEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class OnDeleteLocationEvent extends LocationsEvent {
  final int id;

  const OnDeleteLocationEvent({required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [id];


}
