import 'package:geolocator/geolocator.dart'; // Only for Position type; could abstract further if needed

abstract class LocationRepository {
  Future<Position> getCurrentPosition();
  Position getDefaultPosition();
}