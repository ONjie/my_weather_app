import 'package:equatable/equatable.dart';
import 'package:weather_app/features/locations/domain/entities/favorite_location_entity.dart';

import '../../../../core/local_database/database.dart';

class FavoriteLocationModel extends Equatable {
  const FavoriteLocationModel({
    this.id,
    required this.locationName,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  final int? id;
  final String locationName;
  final String country;
  final double latitude;
  final double longitude;

  FavoriteLocation toFavoriteLocation() {
    return FavoriteLocation(
      id: id!,
      locationName: locationName,
      country: country,
      latitude: latitude,
      longitude: longitude,
    );
  }

  factory FavoriteLocationModel.fromFavoriteLocation({
    required FavoriteLocation favoriteLocation,
  }) {
    return FavoriteLocationModel(
      id: favoriteLocation.id,
      locationName: favoriteLocation.locationName,
      country: favoriteLocation.country,
      latitude: favoriteLocation.latitude,
      longitude: favoriteLocation.longitude,
    );
  }

  FavoriteLocationEntity toFavoriteLocationEntity() {
    return FavoriteLocationEntity(
      id: id,
      locationName: locationName,
      country: country,
      latitude: latitude,
      longitude: longitude,
    );
  }

  factory FavoriteLocationModel.fromLocationEntity({
    required FavoriteLocationEntity favoriteLocation,
  }) {
    return FavoriteLocationModel(
      id: favoriteLocation.id,
      locationName: favoriteLocation.locationName,
      country: favoriteLocation.country,
      latitude: favoriteLocation.latitude,
      longitude: favoriteLocation.longitude,
    );
  }

  @override
  List<Object?> get props => [
        id,
        locationName,
        country,
        latitude,
        longitude,
      ];
}
