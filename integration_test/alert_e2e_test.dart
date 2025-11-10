import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Alert E2E', () {
    setUpAll(() async {
      // Initialize notifications
      await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelGroupKey: 'weather_group',
            channelKey: 'weather_channel',
            channelName: 'Weather Alerts',
            channelDescription: 'Notifications for weather conditions',
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: 'weather_group',
            channelGroupName: 'Weather Notifications',
          ),
        ],
        debug: true,
      );
    });

    setUp(() async {
      // Mock prefs for each test
      SharedPreferences.setMockInitialValues({
        'rainAlert': false,
        'windAlert': false,
      });
    });

    tearDown(() async {
      // Cleanup notifications
      await AwesomeNotifications().cancelAllSchedules();
    });

    testWidgets('sets rain alert and schedules notification', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to settings (adjust finder if button text/icon differs)
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Toggle rain alert (first SwitchListTile for rain)
      await tester.tap(find.byType(SwitchListTile).first);
      await tester.pumpAndSettle();

      // Back to main screen
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Wait for potential async operations
      await tester.pump(Duration(seconds: 1));

      // Verify pending notifications
      final pending = await AwesomeNotifications().listScheduledNotifications();
      expect(pending.length, greaterThan(0));
    });
  });
}
