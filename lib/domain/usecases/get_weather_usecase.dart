import 'package:weather_app/domain/models/weather_response.dart';
import 'package:weather_app/domain/repositories/weather_respository.dart';

class GetWeatherUseCase {
  final WeatherRepository repository;

  GetWeatherUseCase(this.repository);

  Future<WeatherResponse> execute(double lat, double lon) async {
    // Add any business logic here, e.g., validation or caching checks
    if (lat < -90 || lat > 90 || lon < -180 || lon > 180) {
      throw Exception('Invalid coordinates');
    }
    return await repository.getWeather(lat, lon);
  }
}
