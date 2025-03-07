import 'package:equatable/equatable.dart';

import '../../domain/entities/location_entity.dart';

class LocationModel extends Equatable {
  const LocationModel({
    required this.features,
  });

  final List<FeatureModel> features;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> features = json['features'];
    return LocationModel(
      features: features
          .map((feature) => FeatureModel.fromJson(feature))
          .toList(),
    );
  }

  LocationEntity toLocationEntity() {
    return LocationEntity(
      features: features.map((feature) => feature.toFeatureEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [features];
}

class FeatureModel extends Equatable{
  const FeatureModel({
    required this.properties,
  });

  final PropertiesModel properties;

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      properties: PropertiesModel.fromJson(json['properties']),
    );
  }

   FeatureEntity toFeatureEntity(){
    return FeatureEntity(
      properties: properties.toPropertiesEntity(),
    );
   }

  @override
  List<Object?> get props => [properties];
}

class PropertiesModel extends Equatable{

  const PropertiesModel({
    required this.locationName,
    required this.country,
    required this.formatted,
    required this.latitude,
    required this.longitude,
  });

  final String locationName;
  final String country;
  final String formatted;
  final double latitude;
  final double longitude;

  factory PropertiesModel.fromJson(Map<String, dynamic> json) {
    return PropertiesModel(
      locationName: json['city'] as String,
      country: json['country'] as String,
      formatted: json['formatted'] as String,
      latitude: json['lat'] as double,
      longitude: json['lon'] as double,
    );
  }

 PropertiesEntity toPropertiesEntity() {
    return PropertiesEntity(
      locationName: locationName,
      country: country,
      formatted: formatted,
      latitude: latitude,
      longitude: longitude,
    );
  }
  
  @override

  List<Object?> get props => [
    locationName,
    country,
    formatted,
    latitude,
    longitude,
  ];

}