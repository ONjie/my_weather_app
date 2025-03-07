import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final List<FeatureEntity> features;

  const LocationEntity({
    required this.features,
  });

  @override
  List<Object?> get props => [features];
}

class FeatureEntity extends Equatable {
  final PropertiesEntity properties;

  const FeatureEntity({
    required this.properties,
  });

  @override
  List<Object?> get props => [properties];
}

class PropertiesEntity extends Equatable {
  final String locationName;
  final String country;
  final String formatted;
  final double latitude;
  final double longitude;

  const PropertiesEntity({
    required this.locationName,
    required this.country,
    required this.formatted,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        locationName,
        country,
        formatted,
        latitude,
        longitude,
      ];
}
