import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/exceptions/exceptions.dart';

abstract class LocationServices {
  Future<Position> getDeviceLocation();
}

class LocationServicesImpl implements LocationServices {
  @override
  Future<Position> getDeviceLocation() async {
    bool isServiceEnabled;
    LocationPermission permission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw LocationServicesException(
        message: 'Location services are disabled.',
      );
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw LocationServicesException(
          message: 'Location permissions are denied.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationServicesException(
        message:
            'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }
}
