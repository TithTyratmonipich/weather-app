import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/domain/models/weather_data.dart';

part 'current_weather.g.dart';

@JsonSerializable()
class CurrentWeather {
  final int? dt;
  final int? sunrise;
  final int? sunset;
  final double? temp;
  final double? feelsLike;
  final int? pressure;
  final int? humidity;
  final double? dewPoint;
  final double? uvi;
  final int? clouds;
  final int? visibility;
  final double? windSpeed;
  final int? windDeg;
  final double? windGust;
  final List<WeatherData>? weather;
  final double? pop;

  CurrentWeather({
    this.dt,
    this.sunrise,
    this.sunset,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.uvi,
    this.clouds,
    this.visibility,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.weather,
    this.pop,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);
}
