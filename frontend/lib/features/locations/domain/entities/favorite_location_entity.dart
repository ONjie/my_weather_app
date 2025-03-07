import 'package:equatable/equatable.dart';

class FavoriteLocationEntity extends Equatable {
  const FavoriteLocationEntity({
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

  @override
  List<Object?> get props => [
        id,
        locationName,
        country,
        latitude,
        longitude,
      ];
}
