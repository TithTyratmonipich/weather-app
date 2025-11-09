import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/domain/exceptions/api_exception.dart';
import 'package:weather_app/domain/models/weather_response.dart';
import '../../domain/usecases/get_weather_usecase.dart';

class WeatherProvider with ChangeNotifier {
  final GetWeatherUseCase _useCase;

  WeatherResponse? _weather;

  WeatherResponse? get weather => _weather;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  WeatherProvider(this._useCase);

  Future<void> fetchWeather(double lat, double lon) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await _useCase.execute(lat, lon);
    } catch (e) {
      if (e is ApiException) {
        _error = 'Error ${e.code}: ${e.message}';
      } else {
        _error = _handleError(e);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _handleError(dynamic e) {
    if (e is DioException && e.response?.statusCode == 401) {
      return 'Invalid API key. Please check your credentials.';
    } else if (e is TimeoutException) {
      return 'Request timed out. Check your internet connection.';
    } else {
      return e.toString();
    }
  }
}
