import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weather_app/domain/models/weather_response.dart';

import '../../../utils/constants/constants.dart';

part 'weather_api.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  @GET('/onecall')
  Future<WeatherResponse> getWeather(
    @Query('lat') double latitude,
    @Query('lon') double longitude,
    @Query('units') String units, // metrics, to get the degree
    @Query('appid') String apiKey,
    @Query('exclude') String? exclude, // minutely
  );
}
