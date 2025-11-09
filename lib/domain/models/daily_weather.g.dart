// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyWeather _$DailyWeatherFromJson(Map<String, dynamic> json) => DailyWeather(
  dt: (json['dt'] as num?)?.toInt(),
  sunrise: (json['sunrise'] as num?)?.toInt(),
  sunset: (json['sunset'] as num?)?.toInt(),
  moonrise: (json['moonrise'] as num?)?.toInt(),
  moonset: (json['moonset'] as num?)?.toInt(),
  moonPhase: (json['moonPhase'] as num?)?.toDouble(),
  summary: json['summary'] as String?,
  temp: json['temp'] == null
      ? null
      : Temp.fromJson(json['temp'] as Map<String, dynamic>),
  feelsLike: json['feels_like'] == null
      ? null
      : FeelsLike.fromJson(json['feels_like'] as Map<String, dynamic>),
  pressure: (json['pressure'] as num?)?.toInt(),
  humidity: (json['humidity'] as num?)?.toInt(),
  dewPoint: (json['dew_point'] as num?)?.toDouble(),
  windSpeed: (json['wind_speed'] as num?)?.toDouble(),
  windDeg: (json['wind_deg'] as num?)?.toInt(),
  windGust: (json['wind_gust'] as num?)?.toDouble(),
  weather: (json['weather'] as List<dynamic>?)
      ?.map((e) => WeatherData.fromJson(e as Map<String, dynamic>))
      .toList(),
  clouds: (json['clouds'] as num?)?.toInt(),
  pop: (json['pop'] as num?)?.toDouble(),
  rain: (json['rain'] as num?)?.toDouble(),
  uvi: (json['uvi'] as num?)?.toDouble(),
);

FeelsLike _$FeelsLikeFromJson(Map<String, dynamic> json) => FeelsLike(
  day: (json['day'] as num?)?.toDouble(),
  night: (json['night'] as num?)?.toDouble(),
  eve: (json['eve'] as num?)?.toDouble(),
  morn: (json['morn'] as num?)?.toDouble(),
);

Temp _$TempFromJson(Map<String, dynamic> json) => Temp(
  day: (json['day'] as num?)?.toDouble(),
  min: (json['min'] as num?)?.toDouble(),
  max: (json['max'] as num?)?.toDouble(),
  night: (json['night'] as num?)?.toDouble(),
  eve: (json['eve'] as num?)?.toDouble(),
  morn: (json['morn'] as num?)?.toDouble(),
);
