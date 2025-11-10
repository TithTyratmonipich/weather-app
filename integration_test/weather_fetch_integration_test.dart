import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/domain/repositories/weather_respository.dart';

import 'package:weather_app/core/network/dio_client.dart';
import 'package:weather_app/domain/usecases/get_weather_usecase.dart';
import 'package:weather_app/injection_container.dart';

import 'package:weather_app/main.dart' as app;
import 'package:weather_app/presentation/providers/weather_provider.dart';
import 'package:weather_app/utils/constants/constants.dart';

import '../test/get_location_use_case_mocks.mocks.dart'; // Import generated mocks from test/ (relative path; adjust if needed)

// Mock class for location (simulates permission grant and returns fake position)
class MockGeolocatorPlatform extends GeolocatorPlatform {
  @override
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.always;

  @override
  Future<LocationPermission> requestPermission() async =>
      LocationPermission.always;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    // This returns the "current position" from the mock - customize coords as needed
    // (e.g., Phnom Penh from your repo; change for other tests like edge cases)
    return Position(
      latitude: 11.5632,
      // Mock latitude
      longitude: 104.8918,
      // Mock longitude
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 1.0,
      altitudeAccuracy: 1.0,
      heading: 1.0,
      headingAccuracy: 1.0,
      speed: 1.0,
      speedAccuracy: 1.0,
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather Fetch Integration', () {
    late Dio baseDio;
    late DioAdapter dioAdapter;
    late MockGetLocationUseCase mockLocationUseCase;
    late GetWeatherUseCase mockUseCase;

    setUpAll(() async {
      setupLocator();
      baseDio = createDio();
      dioAdapter = DioAdapter(dio: baseDio);

      GeolocatorPlatform.instance = MockGeolocatorPlatform();
      mockLocationUseCase = MockGetLocationUseCase();
      mockUseCase = GetWeatherUseCase(sl<WeatherRepository>());

      // Stub location
      when(mockLocationUseCase.execute()).thenAnswer(
        (_) async => Position(
          latitude: 11.5632,
          longitude: 104.8918,
          timestamp: DateTime.now(),
          accuracy: 1.0,
          altitude: 1.0,
          altitudeAccuracy: 1.0,
          heading: 1.0,
          headingAccuracy: 1.0,
          speed: 1.0,
          speedAccuracy: 1.0,
        ),
      );
    });

    tearDown(() async {
      dioAdapter.close();
    });

    testWidgets('fetches and parses weather data', (tester) async {
      when(mockLocationUseCase.execute()).thenAnswer(
        (_) async => Position(
          latitude: 11.5632,
          longitude: 104.8918,
          timestamp: DateTime.now(),
          accuracy: 1.0,
          altitude: 1.0,
          altitudeAccuracy: 1.0,
          heading: 1.0,
          headingAccuracy: 1.0,
          speed: 1.0,
          speedAccuracy: 1.0,
        ),
      );

      final currentJson = {
        "dt": 1762700098,
        "sunrise": 1762642495,
        "sunset": 1762684418,
        "temp": 27.39,
        "feels_like": 30.63,
        "pressure": 1010,
        "humidity": 80,
        "dew_point": 23.63,
        "uvi": 0,
        "clouds": 89,
        "visibility": 10000,
        "wind_speed": 1.09,
        "wind_deg": 55,
        "wind_gust": 1.19,
        "weather": [
          {
            "id": 502,
            "main": "Rain",
            "description": "heavy intensity rain",
            "icon": "10n",
          },
        ],
        "rain": {"1h": 4.86},
      };
      final json = {
        "lat": 11.5632,
        "lon": 104.8918,
        "timezone": "Asia/Phnom_Penh",
        "timezone_offset": 25200,
        "current": currentJson,
      };

      // Mock the API response (adjust endpoint to match your app's fetch, e.g., '/onecall?lat=...&lon=...')
      dioAdapter.onGet(
        'onecall',
        (request) => request.reply(200, json),
        queryParameters: {
          'lat': 11.5632,
          'lon': 104.8918,
          'appid': defaultApiKey,
          'units': "metric",
        }, // Match your query params
      );

      // Launch app with overridden WeatherProvider (using mocked UseCase)
      await tester.pumpWidget(
        ChangeNotifierProvider<WeatherProvider>(
          create: (_) => WeatherProvider(mockUseCase),
          child: const app.MyApp(), // Your root widget
        ),
      );

      await tester.pumpAndSettle();

      // Wait for fetch to complete (add delay if needed for async)
      await tester.pump(Duration(seconds: 2));

      expect(find.byKey(ValueKey("currentTemp")), findsOneWidget);
      expect(find.text('Phnom Penh'), findsOneWidget); // Adjust
      expect(find.text('Humidity'), findsOneWidget); //for humidity
      expect(find.text('Wind'), findsOneWidget); //for humidity
      expect(find.text('UV Index'), findsOneWidget); //for humidity
    });

    // testWidgets('handles API error gracefully', (tester) async {
    //   // Mock error response (e.g., invalid key)
    //   dioAdapter.onGet(
    //     'onecall',
    //     (request) => request.reply(401, {
    //       'cod': 401,
    //       'message':
    //           'Please note that using One Call 3.0 requires a separate subscription to the One Call by Call plan. Learn more here https://openweathermap.org/price. If you have a valid subscription to the One Call by Call plan, but still receive this error, then please see https://openweathermap.org/faq#error401 for more info.',
    //     }),
    //     queryParameters: {
    //       'lat': 11.5632,
    //       'lon': 104.8918,
    //       'appid': "newTokenApiKey",
    //       'units': "metric",
    //     }, // Match your query params
    //   );
    //
    //   // Launch app with overridden WeatherProvider (using mocked UseCase)
    //   await tester.pumpWidget(
    //     ChangeNotifierProvider<WeatherProvider>(
    //       create: (_) => WeatherProvider(mockUseCase),
    //       child: const app.MyApp(), // Your root widget
    //     ),
    //   );
    //
    //   await tester.pumpAndSettle();
    //
    //   // Wait for fetch
    //   await tester.pump(Duration(seconds: 2));
    //
    //   // Verify error UI (adjust to your error handling, e.g., snackbar or text)
    //   expect(find.text('Error on'), findsOneWidget);
    // });
    //
    // testWidgets('handles no internet error', (tester) async {
    //   // Mock Location UseCase (same as above)
    //   final mockLocationUseCase = MockGetLocationUseCase();
    //   when(mockLocationUseCase.execute()).thenAnswer(
    //     (_) async => Position(
    //       latitude: 11.5632,
    //       longitude: 104.8918,
    //       timestamp: DateTime.now(),
    //       accuracy: 1.0,
    //       altitude: 1.0,
    //       altitudeAccuracy: 1.0,
    //       heading: 1.0,
    //       headingAccuracy: 1.0,
    //       speed: 1.0,
    //       speedAccuracy: 1.0,
    //     ),
    //   );
    //
    //   final baseDio = createDio();
    //   final dioAdapter = DioAdapter(dio: baseDio);
    //
    //   // Mock no internet: Throw DioException for connection failure
    //   dioAdapter.onGet(
    //     'onecall',
    //     (request) => request.throws(
    //       500, // Arbitrary code for error
    //       DioException(
    //         requestOptions: RequestOptions(path: 'onecall'),
    //         error: 'No internet connection',
    //         type: DioExceptionType.connectionError,
    //       ),
    //     ),
    //   );
    //
    //   // Launch app
    //   await tester.pumpWidget(
    //     ChangeNotifierProvider<WeatherProvider>(
    //       create: (_) => WeatherProvider(mockUseCase),
    //       child: const app.MyApp(),
    //     ),
    //   );
    //
    //   await tester.pumpAndSettle();
    //
    //   // Wait for fetch attempt
    //   await tester.pump(Duration(seconds: 2));
    //
    //   // Verify error UI (adjust to your app's error handling, e.g., text or snackbar)
    //   expect(
    //     find.text('Network error: No internet connection'),
    //     findsOneWidget,
    //   ); // From your provider's _error
    //   // Or if snackbar: expect(find.byType(SnackBar), findsOneWidget);
    // });
  });
}
