import 'package:json_annotation/json_annotation.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  WeatherData({this.id, this.main, this.description, this.icon});

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}
