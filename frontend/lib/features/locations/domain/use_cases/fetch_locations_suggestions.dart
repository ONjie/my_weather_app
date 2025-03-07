import 'package:either_dart/either.dart';

import '../../../../core/failures/failures.dart';
import '../entities/location_entity.dart';
import '../repositories/locations_repository.dart';

class FetchLocationsSuggestions {
  final LocationsRepository locationsRepository;

  FetchLocationsSuggestions({required this.locationsRepository});

  Future<Either<Failure, LocationEntity>> execute(
          {required String locationName}) async =>
      await locationsRepository.fetchLocationsSuggestions(
          locationName: locationName);
}
