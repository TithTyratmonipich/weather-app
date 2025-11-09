import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/domain/models/current_weather.dart';
import 'package:weather_app/domain/models/daily_weather.dart';

part 'weather_response.g.dart';

@JsonSerializable(createToJson: false)
class WeatherResponse {
  final double lat;
  final double lon;
  final String timezone;
  final CurrentWeather? current;
  final List<CurrentWeather>? hourly;
  final List<DailyWeather>? daily;
  // Add minutely, alerts if needed

  WeatherResponse({
    required this.lat,
    required this.lon,
    required this.timezone,
    this.current,
    this.hourly,
    this.daily,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherResponseFromJson(json);
}
