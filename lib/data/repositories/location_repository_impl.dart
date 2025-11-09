import 'package:geolocator/geolocator.dart';
import 'package:weather_app/data/datasources/local/location_datasource.dart';
import '../../domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<Position> getCurrentPosition() {
    return dataSource.getCurrentPosition();
  }

  @override
  Position getDefaultPosition() {
    return dataSource.getDefaultPosition();
  }
}
