import 'package:flutter/material.dart';
import 'package:weather_app/domain/models/current_weather.dart';
import 'package:weather_app/domain/models/daily_weather.dart';
import 'package:weather_app/domain/models/weather_response.dart';
import 'package:weather_app/presentation/screens/settings_screen.dart'
    show SettingsScreen;
import 'package:weather_app/utils/date_utils.dart';
import 'package:weather_app/utils/icon_utils.dart';
import 'package:weather_app/utils/string_utils.dart';

class BodyWeatherWidget extends StatelessWidget {
  final WeatherResponse weather;

  const BodyWeatherWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weather.timezone
                                  .split("/")
                                  .last
                                  .replaceAll("_", " "),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "(${weather.current?.dt?.toHourAmPm() ?? ""})",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.settings, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SettingsScreen()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Main Temperature Display
                Center(
                  child: Column(
                    children: [
                      Icon(
                        getWeatherIcon(weather.current?.weather!.first.id ?? 0),
                        color: Colors.white,
                        size: 120,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${weather.current?.temp?.round() ?? 'N/A'}°',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        toTitleCase(
                          weather.current?.weather?.first.description ?? "",
                        ),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // Weather Details Cards
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherDetail(
                        Icons.water_drop,
                        "${weather.current?.humidity}%",
                        "Humidity",
                      ),
                      _buildWeatherDetail(
                        Icons.air,
                        "${weather.current?.windSpeed} km/h",
                        "Wind",
                      ),
                      _buildWeatherDetail(
                        Icons.wb_sunny_outlined,
                        "${weather.current?.uvi}",
                        "UV Index",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Hourly Forecast
                Text(
                  "Today (Hourly)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weather.hourly?.length ?? 0,
                    itemBuilder: (context, index) {
                      if (weather.hourly != null) {
                        return _buildHourlyCard(weather.hourly![index]);
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
                SizedBox(height: 30),

                // Weekly Forecast
                Text(
                  "This Week (Daily)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 80.0 * weather.daily!.length,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: weather.daily?.length ?? 0,
                    itemBuilder: (context, index) {
                      if (weather.daily != null) {
                        return _buildDailyCard(weather.daily![index]);
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildHourlyCard(CurrentWeather currentWeather) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentWeather.dt!.toHourAmPm(),
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 8),
          Icon(
            getWeatherIcon(currentWeather.weather!.first.id!),
            color: Colors.white,
            size: 32,
          ),
          SizedBox(height: 8),
          Text(
            "${currentWeather.temp?.round()}°",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${currentWeather.weather?.first.main}",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCard(DailyWeather weather) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50,
            child: Text(
              weather.dt!.toDayMonth(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 10),

          Icon(
            getWeatherIcon(weather.weather!.first.id!),
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 10),
          Text(
            "${weather.weather!.first.main}°",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "min: ${weather.temp?.min?.round()}°",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "max: ${weather.temp?.max?.round()}°",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
