import 'package:equatable/equatable.dart';

typedef MapJson = Map<String, dynamic>;

class PlaceModel extends Equatable {
  const PlaceModel({
    required this.features,
  });

  factory PlaceModel.fromJson(MapJson json) {
    final data = json['features'] as List<dynamic>;
    return PlaceModel(
      features: data.map((e) => Feature.fromJson(e as MapJson)).toList(),
    );
  }

  MapJson toJson() {
    return {
      'features': features.map((e) => e.toJson()).toList(),
    };
  }

  final List<Feature> features;

  @override
  List<Object?> get props => [features];
}

class Feature extends Equatable {
  const Feature({
    required this.properties,
  });

  factory Feature.fromJson(MapJson json) {
    return Feature(
      properties: Properties.fromJson(json['properties'] as MapJson),
    );
  }

  final Properties properties;

  MapJson toJson() {
    return {
      'properties': properties.toJson(),
    };
  }

  @override
  List<Object?> get props => [properties];
}

class Properties extends Equatable {
  const Properties({
    required this.locationName,
    required this.country,
    required this.formatted,
    required this.lat,
    required this.lon,
  });

  factory Properties.fromJson(MapJson json) {
    return Properties(
      locationName: json['city'] as String,
      country: json['country'] as String,
      formatted: json['formatted'] as String,
      lat: json['lat'] as double,
      lon: json['lon'] as double,
    );
  }

  MapJson toJson() {
    return {
      'city': locationName,
      'country': country,
      'formatted': formatted,
      'lat': lat,
      'lon': lon,
    };
  }

  final String locationName;
  final String country;
  final String formatted;
  final double lat;
  final double lon;

  @override
  List<Object?> get props => [
        locationName,
        country,
        formatted,
        lat,
        lon,
      ];
}
