import 'package:mockito/annotations.dart';
import 'package:weather_app/domain/usecases/get_location_usecase.dart';  // Import the real class to mock

// Generate mocks for classes used across tests
@GenerateMocks([GetLocationUseCase])  // Add more classes here if needed for other tests

void main() {}  // Empty main to make it a valid Dart file for generation