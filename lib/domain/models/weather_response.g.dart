// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherResponse _$WeatherResponseFromJson(Map<String, dynamic> json) =>
    WeatherResponse(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      timezone: json['timezone'] as String,
      current: json['current'] == null
          ? null
          : CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
      hourly: (json['hourly'] as List<dynamic>?)
          ?.map((e) => CurrentWeather.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily: (json['daily'] as List<dynamic>?)
          ?.map((e) => DailyWeather.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherResponseToJson(WeatherResponse instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'timezone': instance.timezone,
      'current': instance.current,
      'hourly': instance.hourly,
      'daily': instance.daily,
    };
