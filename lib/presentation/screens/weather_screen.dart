import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/exceptions/location_exceptions.dart';
import 'package:weather_app/domain/usecases/get_location_usecase.dart';
import 'package:weather_app/injection_container.dart';
import 'package:weather_app/presentation/widgets/body_weather_widget.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _getLocationAndFetch();
  }

  Future<void> _getLocationAndFetch() async {
    setState(() => _permissionDenied = false);

    final useCase = sl<GetLocationUseCase>();

    try {
      final position = await useCase.execute();
      if (mounted) {
        context.read<WeatherProvider>().fetchWeather(
          position.latitude,
          position.longitude,
        );
      }
    } on AppLocationPermissionDeniedException catch (e) {
      setState(() => _permissionDenied = true);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
      useCase.repository.getDefaultPosition();
    } on AppLocationPermissionDeniedForeverException catch (e) {
      setState(() => _permissionDenied = true);
      if (mounted) {
        // Show prompt dialog before opening settings
        final shouldOpen = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Access Required'),
            content: const Text(
              'Location permissions are permanently denied. Would you like to open app settings to enable them?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                // Dismiss
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirm
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );

        if (shouldOpen == true) {
          await Geolocator.openAppSettings(); // Open settings
          // After returning from settings, optionally re-check permissions
          _getLocationAndFetch(); // Retry automatically for convenience
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Using default location instead.')),
          );
        }
      }
    } on AppLocationServiceDisabledException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Weather App')),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.error != null) {
            return Center(child: Text(provider.error!));
          } else if (_permissionDenied) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You have not allowed location access.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _getLocationAndFetch, // Retry re-requests
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (provider.weather != null) {
            final weather = provider.weather!;
            return RefreshIndicator(
              onRefresh: () async {
                _getLocationAndFetch();
              },
              child: SingleChildScrollView(
                child: BodyWeatherWidget(weather: weather),
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
            return const Center(child: Text('Loading weather...'));
          }
        },
      ),
    );
  }
}
