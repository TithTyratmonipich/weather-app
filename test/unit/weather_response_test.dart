import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/domain/models/current_weather.dart';
import 'package:weather_app/domain/models/weather_response.dart';

void main() {
  group('HourlyForecast', () {
    test('parses JSON correctly', () {
      final json = {
        "dt": 1762696800,
        "temp": 27.43,
        "feels_like": 30.6,
        "pressure": 1010,
        "humidity": 79,
        "dew_point": 23.46,
        "uvi": 0,
        "clouds": 89,
        "visibility": 10000,
        "wind_speed": 1.32,
        "wind_deg": 59,
        "wind_gust": 1.41,
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n",
          },
        ],
        "pop": 0.88,
        "rain": {"1h": 0.12},
      };

      final forecast = CurrentWeather.fromJson(json);

      expect(forecast.dt, 1762696800);
      expect(forecast.temp, 27.43);
      expect(forecast.windSpeed, 1.32);
      expect(forecast.pop, 0.88);
      expect(forecast.rain?.the1H, 0.12);
      expect(forecast.weather?.first.main, 'Rain');
      expect(forecast.weather?.first.description, 'light rain');
    });

    test('handles missing rain key', () {
      final json = {
        "dt": 1762696800,
        "temp": 27.43,
        "feels_like": 30.6,
        "pressure": 1010,
        "humidity": 79,
        "dew_point": 23.46,
        "uvi": 0,
        "clouds": 89,
        "visibility": 10000,
        "wind_speed": 1.32,
        "wind_deg": 59,
        "wind_gust": 1.41,
        "weather": [
          {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n",
          },
        ],
        "pop": 0.88,
      };

      final forecast = CurrentWeather.fromJson(json);

      expect(forecast.rain, null); // Default
    });
  });

  group('WeatherResponse', () {
    test('parses JSON with hourly list', () {
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
        "hourly": [
          {
            "dt": 1762696800,
            "temp": 27.43,
            "feels_like": 30.6,
            "pressure": 1010,
            "humidity": 79,
            "dew_point": 23.46,
            "uvi": 0,
            "clouds": 89,
            "visibility": 10000,
            "wind_speed": 1.32,
            "wind_deg": 59,
            "wind_gust": 1.41,
            "weather": [
              {
                "id": 500,
                "main": "Rain",
                "description": "light rain",
                "icon": "10n",
              },
            ],
            "pop": 0.88,
          },
        ],
      };

      final model = WeatherResponse.fromJson(json);

      expect(model.lat, 11.5632);
      expect(model.lon, 104.8918);
      expect(model.timezone, "Asia/Phnom_Penh");
      expect(model.current, isA<CurrentWeather>());
      expect(model.hourly, isA<List<CurrentWeather>>());
      expect(model.hourly?.length, 1); // Based on sample
    });
  });
}
