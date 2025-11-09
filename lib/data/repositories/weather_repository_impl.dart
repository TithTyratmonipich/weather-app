import 'package:dio/dio.dart';
import 'package:weather_app/core/network/dio_client.dart';
import 'package:weather_app/data/datasources/network/weather_api.dart';
import 'package:weather_app/domain/exceptions/api_exception.dart';
import 'package:weather_app/domain/models/weather_response.dart';
import 'package:weather_app/domain/repositories/weather_respository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  late final WeatherApi _api;
  final String _apiKey;

  WeatherRepositoryImpl(this._apiKey) {
    final dio = createDio();
    _api = WeatherApi(dio);
  }

  @override
  Future<WeatherResponse> getWeather(double lat, double lon) async {
    try {
      final response = await _api.getWeather(
        lat,
        lon,
        'metric',
        _apiKey,
        "minutely",
      );
      // Map data model to domain entity if they differ
      return _mapToDomain(response);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final int cod = errorData['cod'] ?? e.response!.statusCode ?? -1;
        final String message = errorData['message'] ?? 'Unknown error';
        throw ApiException(cod, message); // Propagate with details
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }

  WeatherResponse _mapToDomain(WeatherResponse model) {
    // Example mapping; adjust as needed
    return WeatherResponse(
      lat: model.lat,
      lon: model.lon,
      timezone: model.timezone,
      current: model.current,
      hourly: model.hourly,
      daily: model.daily,
    );
  }
}
