import 'package:geolocator/geolocator.dart';
import '../../../domain/exceptions/location_exceptions.dart';

class LocationDataSource {
  final double defaultLat;
  final double defaultLon;

  LocationDataSource({
    this.defaultLat = 11.576275587048777,
    this.defaultLon = 104.92309268962967,
  });

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw AppLocationServiceDisabledException(
        'Location services are disabled.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw AppLocationPermissionDeniedException(
          'Location permission denied.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw AppLocationPermissionDeniedForeverException(
        'Location permissions are permanently denied.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Position getDefaultPosition() {
    return Position(
      latitude: defaultLat,
      longitude: defaultLon,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }
}
