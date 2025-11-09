class AppLocationServiceDisabledException implements Exception {
  final String message;

  AppLocationServiceDisabledException(this.message);
}

class AppLocationPermissionDeniedException implements Exception {
  final String message;

  AppLocationPermissionDeniedException(this.message);
}

class AppLocationPermissionDeniedForeverException implements Exception {
  final String message;

  AppLocationPermissionDeniedForeverException(this.message);
}
