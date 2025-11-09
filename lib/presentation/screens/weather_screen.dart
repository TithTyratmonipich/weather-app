import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/exceptions/location_exceptions.dart';
import 'package:weather_app/domain/usecases/get_location_usecase.dart';
import 'package:weather_app/injection_container.dart';
import 'package:weather_app/presentation/widgets/body_weather_widget.dart';
import 'package:weather_app/presentation/widgets/weather_loading_widget.dart';
import 'package:weather_app/presentation/widgets/weather_error_widget.dart';
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
          _getLocationAndFetch();
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
        await Geolocator.openLocationSettings(); // Open settings
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
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const WeatherLoadingWidget();
          } else if (_permissionDenied) {
            return WeatherErrorWidget(
              title: 'You have not allowed location access.',
              onRetry: _getLocationAndFetch,
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
            return WeatherErrorWidget(
              title: 'Error on ${provider.error!}',
              onRetry: _getLocationAndFetch,
            );
          } else {
            return const WeatherLoadingWidget();
          }
        },
      ),
    );
  }
}
