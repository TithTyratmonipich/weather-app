import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

IconData getWeatherIcon(int id) {
  if (id >= 200 && id < 300) return WeatherIcons.thunderstorm;
  if (id >= 300 && id < 400) return WeatherIcons.raindrops;
  if (id >= 500 && id < 600) return WeatherIcons.rain;
  if (id >= 600 && id < 700) return WeatherIcons.snow;
  if (id == 800) return WeatherIcons.day_sunny;
  if (id > 800) return WeatherIcons.cloudy;
  return WeatherIcons.na; // Default
}