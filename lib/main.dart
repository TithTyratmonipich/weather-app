import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/datasources/weather_api.dart';
import 'package:weather_app/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/data/repositories/weather_respository.dart';
import 'package:weather_app/domain/usecases/get_weather_usecase.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';
import 'package:weather_app/presentation/screens/weather_screen.dart';
import 'package:weather_app/utils/constants/constants.dart'; // Add get_it package

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<WeatherApi>(() => WeatherApi(sl<Dio>()));
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(defaultApiKey),
  );
  sl.registerLazySingleton<GetWeatherUseCase>(
    () => GetWeatherUseCase(sl<WeatherRepository>()),
  );
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(sl<GetWeatherUseCase>()),
        ),
      ],
      child: MaterialApp(
        home: const WeatherScreen(
          lat: 11.530020473583622,
          lon: 104.8471329839505,
          // 11.530020473583622, 104.8471329839505
        ), // Example coords
      ),
    );
  }
}
