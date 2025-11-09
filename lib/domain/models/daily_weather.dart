import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/domain/models/weather_data.dart';

part 'daily_weather.g.dart';

@JsonSerializable()
class DailyWeather {
  final int? dt;
  final int? sunrise;
  final int? sunset;
  final int? moonrise;
  final int? moonset;
  final double? moonPhase;
  final String? summary;
  final Temp? temp;
  @JsonKey(name: "feels_like")
  final FeelsLike? feelsLike;
  final int? pressure;
  final int? humidity;
  @JsonKey(name: "dew_point")
  final double? dewPoint;
  @JsonKey(name: "wind_speed")
  final double? windSpeed;
  @JsonKey(name: "wind_deg")
  final int? windDeg;
  @JsonKey(name: "wind_gust")
  final double? windGust;
  final List<WeatherData>? weather;
  final int? clouds;
  final double? pop;
  final double? rain;
  final double? uvi;

  DailyWeather({
    this.dt,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.summary,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.weather,
    this.clouds,
    this.pop,
    this.rain,
    this.uvi,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherFromJson(json);
}

@JsonSerializable()
class FeelsLike {
  final double? day;
  final double? night;
  final double? eve;
  final double? morn;

  FeelsLike({this.day, this.night, this.eve, this.morn});

  factory FeelsLike.fromJson(Map<String, dynamic> json) =>
      _$FeelsLikeFromJson(json);
}

@JsonSerializable()
class Temp {
  final double? day;
  final double? min;
  final double? max;
  final double? night;
  final double? eve;
  final double? morn;

  Temp({this.day, this.min, this.max, this.night, this.eve, this.morn});

  factory Temp.fromJson(Map<String, dynamic> json) => _$TempFromJson(json);
}
