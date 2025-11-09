import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/domain/models/weather_data.dart';

part 'current_weather.g.dart';

@JsonSerializable()
class CurrentWeather {
  final int? dt;
  final int? sunrise;
  final int? sunset;
  final double? temp;
  @JsonKey(name: "feels_like")
  final double? feelsLike;
  final int? pressure;
  final int? humidity;
  @JsonKey(name: "dew_point")
  final double? dewPoint;
  final double? uvi;
  final int? clouds;
  final int? visibility;
  @JsonKey(name: "wind_speed")
  final double? windSpeed;
  @JsonKey(name: "wind_deg")
  final int? windDeg;
  @JsonKey(name: "wind_gust")
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
