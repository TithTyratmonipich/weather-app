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
  feelsLike: json['feelsLike'] == null
      ? null
      : FeelsLike.fromJson(json['feelsLike'] as Map<String, dynamic>),
  pressure: (json['pressure'] as num?)?.toInt(),
  humidity: (json['humidity'] as num?)?.toInt(),
  dewPoint: (json['dewPoint'] as num?)?.toDouble(),
  windSpeed: (json['windSpeed'] as num?)?.toDouble(),
  windDeg: (json['windDeg'] as num?)?.toInt(),
  windGust: (json['windGust'] as num?)?.toDouble(),
  weather: (json['weather'] as List<dynamic>?)
      ?.map((e) => WeatherData.fromJson(e as Map<String, dynamic>))
      .toList(),
  clouds: (json['clouds'] as num?)?.toInt(),
  pop: (json['pop'] as num?)?.toDouble(),
  rain: (json['rain'] as num?)?.toDouble(),
  uvi: (json['uvi'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DailyWeatherToJson(DailyWeather instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'moonrise': instance.moonrise,
      'moonset': instance.moonset,
      'moonPhase': instance.moonPhase,
      'summary': instance.summary,
      'temp': instance.temp,
      'feelsLike': instance.feelsLike,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
      'dewPoint': instance.dewPoint,
      'windSpeed': instance.windSpeed,
      'windDeg': instance.windDeg,
      'windGust': instance.windGust,
      'weather': instance.weather,
      'clouds': instance.clouds,
      'pop': instance.pop,
      'rain': instance.rain,
      'uvi': instance.uvi,
    };

FeelsLike _$FeelsLikeFromJson(Map<String, dynamic> json) => FeelsLike(
  day: (json['day'] as num?)?.toDouble(),
  night: (json['night'] as num?)?.toDouble(),
  eve: (json['eve'] as num?)?.toDouble(),
  morn: (json['morn'] as num?)?.toDouble(),
);

Map<String, dynamic> _$FeelsLikeToJson(FeelsLike instance) => <String, dynamic>{
  'day': instance.day,
  'night': instance.night,
  'eve': instance.eve,
  'morn': instance.morn,
};

Temp _$TempFromJson(Map<String, dynamic> json) => Temp(
  day: (json['day'] as num?)?.toDouble(),
  min: (json['min'] as num?)?.toDouble(),
  max: (json['max'] as num?)?.toDouble(),
  night: (json['night'] as num?)?.toDouble(),
  eve: (json['eve'] as num?)?.toDouble(),
  morn: (json['morn'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TempToJson(Temp instance) => <String, dynamic>{
  'day': instance.day,
  'min': instance.min,
  'max': instance.max,
  'night': instance.night,
  'eve': instance.eve,
  'morn': instance.morn,
};
