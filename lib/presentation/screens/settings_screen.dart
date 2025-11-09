import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/services/notification_service.dart';
import 'package:weather_app/domain/usecases/check_weather_alerts.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _rainAlert = false;
  bool _windAlert = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    NotificationService().requestPermissions();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rainAlert = prefs.getBool('rainAlert') ?? false;
      _windAlert = prefs.getBool('windAlert') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rainAlert', _rainAlert);
    prefs.setBool('windAlert', _windAlert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF50B5E9), Color(0xFF7DCEF3)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 40),
                SwitchListTile(
                  activeTrackColor: Colors.white,
                  activeThumbColor: Color(0xFF4A90E2),
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: Colors.red.shade50,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable Rain Alert',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '(if probability > 50%)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  value: _rainAlert,
                  onChanged: (val) {
                    setState(() => _rainAlert = val);
                    _savePreferences();
                    if (_rainAlert &&
                        context.read<WeatherProvider>().weather != null) {
                      checkAndScheduleAlerts(
                        context.read<WeatherProvider>().weather!,
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: _rainAlert ? Colors.green : Colors.red,
                        content: Text(
                          _rainAlert
                              ? 'Set Enable Rain Alert'
                              : "Disable Rain Alert",
                        ),
                      ),
                    );
                  },
                ),
                SwitchListTile(
                  activeTrackColor: Colors.white,
                  activeThumbColor: Color(0xFF4A90E2),
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: Colors.red.shade50,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable High Wind Alert',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '(if speed > 30 km/h)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  value: _windAlert,
                  onChanged: (val) {
                    setState(() => _windAlert = val);
                    _savePreferences();
                    if (_windAlert &&
                        context.read<WeatherProvider>().weather != null) {
                      checkAndScheduleAlerts(
                        context.read<WeatherProvider>().weather!,
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: _rainAlert ? Colors.green : Colors.red,
                        content: Text(
                          _rainAlert
                              ? 'Set Enable High Wind Alert'
                              : "Disable High Wind Alert",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
