import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:weather_app/data/datasources/local/location_datasource.dart';
import 'package:weather_app/data/datasources/network/weather_api.dart';
import 'package:weather_app/data/repositories/location_repository_impl.dart';
import 'package:weather_app/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/domain/repositories/location_repository.dart';
import 'package:weather_app/domain/repositories/weather_respository.dart';
import 'package:weather_app/domain/usecases/get_location_usecase.dart';
import 'package:weather_app/domain/usecases/get_weather_usecase.dart';
import 'package:weather_app/utils/constants/constants.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<WeatherApi>(() => WeatherApi(sl<Dio>()));
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(defaultApiKey),
  );
  sl.registerLazySingleton<GetWeatherUseCase>(
    () => GetWeatherUseCase(sl<WeatherRepository>()),
  );
  sl.registerLazySingleton<LocationDataSource>(() => LocationDataSource());
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(sl<LocationDataSource>()),
  );
  sl.registerLazySingleton<GetLocationUseCase>(
    () => GetLocationUseCase(sl<LocationRepository>()),
  );
}
