import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/3.0/',
      // Matches your Retrofit baseUrl
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'}, // If needed
    ),
  );

  // Add interceptors for logging/errors (optional but recommended)
  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => log(obj.toString()), // Or use a logger package
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) {
        // Global error handling, e.g., for 401/429
        log('Dio error: ${e.message}');
        return handler.next(e);
      },
    ),
  );

  return dio;
}
