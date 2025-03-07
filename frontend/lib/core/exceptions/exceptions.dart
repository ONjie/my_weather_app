class ServerException implements Exception {
  final String? message;

  ServerException({required this.message});
}

class OtherException implements Exception {
  final String? message;

  OtherException({required this.message});
}

class LocationServicesException implements Exception {
  final String? message;
  
  LocationServicesException({required this.message});
}
class DatabaseException implements Exception {
  final String? message;

  DatabaseException({required this.message});
}
