import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter_vcf/interceptors/token_refresh_interceptor.dart';

/// App configuration - single source of truth
class AppConfig {
  // ============================================================
  // CHANGE THIS for production deployment
  // ============================================================
  static const String productionUrl = 'http://your-server.com/api/';

  /// Set to false for production builds
  static const bool useLocalDev = true;

  /// Auto-detects the correct URL based on platform
  /// - Android emulator: 10.0.2.2 (special IP to reach host)
  /// - iOS simulator/macOS: localhost works directly
  static String get apiBaseUrl {
    if (!useLocalDev) return productionUrl;

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/';
    }
    return 'http://localhost:8000/api/';
  }

  /// Creates a Dio instance with baseUrl pre-configured
  /// Includes automatic token refresh interceptor for 401 errors
  static Dio createDio({bool withLogging = false}) {
    final dio = Dio(
      BaseOptions(baseUrl: apiBaseUrl, contentType: 'application/json'),
    );

    // Add token refresh interceptor first (before logging)
    dio.interceptors.add(TokenRefreshInterceptor());

    if (withLogging) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
        ),
      );
    }

    return dio;
  }
}
