import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/services/notification_service.dart';
import 'package:weather_app/domain/models/current_weather.dart';
import 'package:weather_app/domain/models/rain_model.dart';
import 'package:weather_app/domain/models/weather_data.dart';
import 'package:weather_app/domain/models/weather_response.dart';
import 'package:weather_app/domain/usecases/check_weather_alerts.dart';

import 'check_weather_alerts_test.mocks.dart';

@GenerateMocks([NotificationService, SharedPreferences])
void main() {
  late MockNotificationService mockNotificationService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockNotificationService = MockNotificationService();
    mockPrefs = MockSharedPreferences();
  });

  group('checkAndScheduleAlerts', () {
    // test('schedules rain alert when conditions met', () async {
    //   when(mockPrefs.getBool('rainAlert')).thenReturn(true);
    //   when(mockPrefs.getBool('windAlert')).thenReturn(false);
    //
    //   final futureDt =
    //       (DateTime.now().add(Duration(hours: 2)).millisecondsSinceEpoch ~/
    //       1000);
    //
    //   final forecast = CurrentWeather(
    //     dt: futureDt,
    //     temp: 25.0,
    //     windSpeed: 20.0,
    //     pop: 0.6,
    //     rain: Rain(the1H: 1.0),
    //     weather: [
    //       WeatherData(id: 502, main: 'Rain', description: 'light rain'),
    //     ],
    //   );
    //
    //   final weather = WeatherResponse(
    //     lat: 11.5632,
    //     lon: 104.8918,
    //     timezone: "Asia/Phnom_Penh",
    //     current: forecast,
    //     hourly: [forecast],
    //   );
    //
    //   await checkAndScheduleAlerts(
    //     weather,
    //     prefs: mockPrefs,
    //     notificationService: mockNotificationService,
    //   );
    //
    //   verify(
    //     // mockNotificationService.scheduleAlert(
    //     //   1,
    //     //   'Rain Alert',
    //     //   'Rain expected at 17:00 with ${forecast.rain!.the1H! * 100}% probability.',
    //     //   DateTime.now().add(Duration(hours: 2)),
    //     //   'rain_details',
    //     // ),
    //     mockNotificationService.scheduleAlert(any, any, any, any, any),
    //   ).called(1);
    // });

    test('does not schedule if thresholds not met', () async {
      when(mockPrefs.getBool('rainAlert')).thenReturn(true);
      when(mockPrefs.getBool('windAlert')).thenReturn(false);

      final futureDt =
          (DateTime.now().add(Duration(hours: 2)).millisecondsSinceEpoch ~/
          1000);

      final forecast = CurrentWeather(
        dt: futureDt,
        temp: 25.0,
        windSpeed: 20.0,
        pop: 0.4,
        // Below 50%
        rain: Rain(the1H: 0.0),
        weather: [
          WeatherData(id: 800, main: 'Clear', description: 'clear sky'),
        ],
      );

      final weather = WeatherResponse(
        lat: 11.5632,
        lon: 104.8918,
        timezone: "Asia/Phnom_Penh",
        current: forecast,
        hourly: [forecast],
      );

      await checkAndScheduleAlerts(
        weather,
        prefs: mockPrefs,
        notificationService: mockNotificationService,
      );

      verifyNever(
        mockNotificationService.scheduleAlert(any, any, any, any, any),
      );
    });
  });
}
