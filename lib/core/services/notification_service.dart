import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> init() async {
    await AwesomeNotifications().initialize(
      '@mipmap/ic_launcher', // Your app icon
      [
        NotificationChannel(
          channelKey: 'weather_channel',
          channelName: 'Weather Alerts',
          channelDescription: 'Notifications for weather conditions',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  Future<void> requestPermissions() async {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  Future<bool> areNotificationsAllowed() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  Future<void> ensureChannelExists() async {
    // Fallback: Create/update channel if not found
    await AwesomeNotifications().setChannel(
      NotificationChannel(
        channelGroupKey: 'weather_group',
        channelKey: 'weather_channel',
        channelName: 'Weather Alerts',
        channelDescription: 'Notifications for weather conditions',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
      forceUpdate:
          false, // Set true only if updating (deletes old notifications)
    );
  }

  Future<void> scheduleAlert(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
    String payload,
  ) async {
    await requestPermissions(); // Ensure permissions
    await ensureChannelExists(); // Create channel if missing

    final String localTimeZone = await AwesomeNotifications()
        .getLocalTimeZoneIdentifier();

    final dateNow = DateTime.now().add(Duration(seconds: 10));
    log('Scheduling alert at $scheduledDate in timezone $localTimeZone');

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'weather_channel',
        title: title,
        body: body,
        payload: {'data': payload}, // For handling taps
      ),
      schedule: NotificationCalendar.fromDate(
        // date: scheduledDate,
        date: scheduledDate,
        // timeZone: localTimeZone,
        allowWhileIdle: true,
        preciseAlarm: true, // For exact timing (requires permission)
        repeats: false,
      ),
    );
  }

  Future<void> cancelAll() async {
    await AwesomeNotifications().cancelAllSchedules();
  }
}
