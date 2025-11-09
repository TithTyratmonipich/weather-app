// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentWeather _$CurrentWeatherFromJson(Map<String, dynamic> json) =>
    CurrentWeather(
      dt: (json['dt'] as num?)?.toInt(),
      sunrise: (json['sunrise'] as num?)?.toInt(),
      sunset: (json['sunset'] as num?)?.toInt(),
      temp: (json['temp'] as num?)?.toDouble(),
      feelsLike: (json['feelsLike'] as num?)?.toDouble(),
      pressure: (json['pressure'] as num?)?.toInt(),
      humidity: (json['humidity'] as num?)?.toInt(),
      dewPoint: (json['dewPoint'] as num?)?.toDouble(),
      uvi: (json['uvi'] as num?)?.toDouble(),
      clouds: (json['clouds'] as num?)?.toInt(),
      visibility: (json['visibility'] as num?)?.toInt(),
      windSpeed: (json['windSpeed'] as num?)?.toDouble(),
      windDeg: (json['windDeg'] as num?)?.toInt(),
      windGust: (json['windGust'] as num?)?.toDouble(),
      weather: (json['weather'] as List<dynamic>?)
          ?.map((e) => WeatherData.fromJson(e as Map<String, dynamic>))
          .toList(),
      pop: (json['pop'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CurrentWeatherToJson(CurrentWeather instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'temp': instance.temp,
      'feelsLike': instance.feelsLike,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
      'dewPoint': instance.dewPoint,
      'uvi': instance.uvi,
      'clouds': instance.clouds,
      'visibility': instance.visibility,
      'windSpeed': instance.windSpeed,
      'windDeg': instance.windDeg,
      'windGust': instance.windGust,
      'weather': instance.weather,
      'pop': instance.pop,
    };
