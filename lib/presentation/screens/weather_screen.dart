import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/utils/date_utils.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends StatelessWidget {
  final double lat;
  final double lon;

  const WeatherScreen({super.key, required this.lat, required this.lon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.error != null) {
            return Center(child: Text(provider.error!));
          } else if (provider.weather != null) {
            final weather = provider.weather!;
            return RefreshIndicator(
              onRefresh: () async {
                await provider.fetchWeather(lat, lon);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Location: ${weather.timezone}'),
                    const SizedBox(height: 16),
                    Text('Current Temp: ${weather.current?.temp ?? 'N/A'}°C'),
                    const SizedBox(height: 16),
                    const Text('Hourly Forecast:'),
                    if (weather.hourly != null)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: weather.hourly!.length,
                          itemBuilder: (context, index) {
                            final hour = weather.hourly![index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      hour.dt!.toHourAmPm(), // 12 PM, 1 PM, etc.
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('${hour.temp}°C'),
                                    if (hour.weather?.isNotEmpty == true)
                                      Text(hour.weather!.first.description ?? ""),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Text('Daily Forecast:'),
                    if (weather.daily != null)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: weather.daily!.length,
                        itemBuilder: (context, index) {
                          final day = weather.daily![index];
                          return ListTile(
                            leading: const Icon(Icons.wb_sunny),
                            title: Text(day.dt!.toDayMonth()), // 24 May, 25 May, etc.
                            subtitle: Text('H: ${day.temp?.max}°C | L: ${day.temp?.min}°C'),
                            trailing: Text(
                              day.dt!.toHourAmPm('h a'), // optional: show time of day (e.g. sunrise)
                            ),
                          );
                          return ListTile(
                            title: Text('${day.dt?.toUtcPlus7String()}'), // Format date
                            subtitle: Text(
                              'High: ${day.temp?.max}°C, Low: ${day.temp?.min}°C',
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          } else if (provider.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(provider.error!),
                ),
              );
            });
            return Center(child: Text(provider.error!));
          } else {
            // Initial state: Trigger fetch
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.fetchWeather(lat, lon);
            });
            return const Center(child: Text('Loading weather...'));
          }
        },
      ),
    );
  }
}
