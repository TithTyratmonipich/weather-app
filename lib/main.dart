import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';
import 'package:weather_app/presentation/screens/weather_screen.dart';

import 'domain/usecases/get_weather_usecase.dart';
import 'injection_container.dart';

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
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Aptos'),
        home: WeatherScreen(),
      ),
    );
  }
}
