import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/services/notification_service.dart';
import 'package:weather_app/domain/models/weather_response.dart';
import 'package:weather_app/utils/date_utils.dart';

Future<void> checkAndScheduleAlerts(WeatherResponse weather) async {
  final prefs = await SharedPreferences.getInstance();
  final bool rainAlert = prefs.getBool('rainAlert') ?? false;
  final bool windAlert = prefs.getBool('windAlert') ?? false;
  log("checkAndScheduleAlerts, rainAlert: $rainAlert, windAlert, $windAlert");

  const double rainThreshold = 50.0; // >50% probability
  const double windThreshold = 30.0; // >30 km/h

  if (weather.hourly != null) {
    for (var forecast in weather.hourly!) {
      if (forecast.pop != null) {
        final double rainProb = forecast.pop! * 100; // Convert to percentage
        final forecastTime = DateTime.parse(
          forecast.dt!.toUtcPlus7String("yyyy-MM-dd HH:mm:ss"),
        );
        if (rainAlert &&
            rainProb > rainThreshold &&
            forecast.weather != null &&
            forecast.rain != null) {
          // Optional: Confirm with weather.main or rainVolume
          bool isRainConfirmed =
              forecast.weather!.first.main == 'Rain' ||
              forecast.weather!.first.description!.contains('rain') ||
              (forecast.rain!.the1H ?? 0) > 0;

          log("isRainConfirmed: $isRainConfirmed");
          if (isRainConfirmed) {
            final alertTime = forecastTime.subtract(Duration(hours: 1));
            log(
              "alertTime.isAfter(DateTime.now()): ${alertTime.isAfter(DateTime.now())}",
            );
            if (alertTime.isAfter(DateTime.now())) {
              await NotificationService().scheduleAlert(
                1,
                'Rain Alert',
                'Rain expected at ${forecastTime.hour}:00 with $rainProb% probability.',
                alertTime,
                'rain_details',
              );
            }
          }
        }

        if (windAlert &&
            forecast.windSpeed != null &&
            forecast.windSpeed! > windThreshold) {
          final alertTime = forecastTime.subtract(Duration(hours: 1));
          if (alertTime.isAfter(DateTime.now())) {
            await NotificationService().scheduleAlert(
              2,
              'High Wind Alert',
              'Winds up to ${forecast.windSpeed} km/h expected at ${forecastTime.hour}:00.',
              alertTime,
              'wind_details',
            );
          }
        }
      }
    }
  }
}
