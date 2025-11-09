import 'package:weather_app/domain/models/weather_response.dart';

abstract class WeatherRepository {
  Future<WeatherResponse> getWeather(double lat, double lon);
}