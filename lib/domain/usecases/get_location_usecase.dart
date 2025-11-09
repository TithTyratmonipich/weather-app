import 'package:geolocator/geolocator.dart';
import 'package:weather_app/domain/exceptions/location_exceptions.dart';
import 'package:weather_app/domain/repositories/location_repository.dart';

class GetLocationUseCase {
  final LocationRepository repository;

  GetLocationUseCase(this.repository);

  Future<Position> execute() async {
    try {
      return await repository.getCurrentPosition();
    } on AppLocationServiceDisabledException {
      rethrow;
    } on AppLocationPermissionDeniedException {
      rethrow;
    } on AppLocationPermissionDeniedForeverException {
      rethrow;
    } catch (e) {
      return repository.getDefaultPosition();
    }
  }
}
