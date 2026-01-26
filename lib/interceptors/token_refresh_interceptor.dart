import 'package:dio/dio.dart';
import 'package:flutter_vcf/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interceptor that automatically refreshes JWT token on 401 errors
class TokenRefreshInterceptor extends Interceptor {
  final Dio _refreshDio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
  bool _isRefreshing = false;
  final List<({RequestOptions options, ErrorInterceptorHandler handler})>
  _pendingRequests = [];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 errors
    if (err.response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      // Skip refresh for login/refresh endpoints to avoid infinite loops
      if (requestOptions.path.contains('/login') ||
          requestOptions.path.contains('/refresh')) {
        return handler.next(err);
      }

      // If already refreshing, queue this request
      if (_isRefreshing) {
        _pendingRequests.add((options: requestOptions, handler: handler));
        return;
      }

      _isRefreshing = true;

      try {
        // Get current token
        final prefs = await SharedPreferences.getInstance();
        final currentToken = prefs.getString('jwt_token');

        if (currentToken == null || currentToken.isEmpty) {
          print('[TokenRefresh] No token found, cannot refresh');
          _isRefreshing = false;
          _rejectPendingRequests(err);
          return handler.next(err);
        }

        print(
          '[TokenRefresh] Attempting to refresh token for: ${requestOptions.path}',
        );

        // Attempt to refresh token
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            contentType: 'application/json',
          ),
        );

        final response = await refreshDio.post(
          '/refresh',
          options: Options(headers: {'Authorization': 'Bearer $currentToken'}),
        );

        if (response.statusCode == 200) {
          final data = response.data;

          if (data['success'] == true && data['data'] != null) {
            // Extract new token (raw, without Bearer prefix)
            final newToken = data['data']['token'];

            print('[TokenRefresh] Token refreshed successfully');

            // Save raw token (Bearer prefix added when making API calls)
            await prefs.setString('jwt_token', newToken);

            // Retry original request with new token
            final opts = requestOptions.copyWith(
              headers: {
                ...requestOptions.headers,
                'Authorization': 'Bearer $newToken',
              },
            );

            try {
              print(
                '[TokenRefresh] Retrying original request: ${requestOptions.path}',
              );
              final retryResponse = await _refreshDio.fetch(opts);
              _isRefreshing = false;

              // Resolve pending requests
              _resolvePendingRequests('Bearer $newToken');

              print('[TokenRefresh] Request retry successful');
              return handler.resolve(
                Response(
                  data: retryResponse.data,
                  statusCode: retryResponse.statusCode,
                  statusMessage: retryResponse.statusMessage,
                  requestOptions: requestOptions,
                ),
              );
            } catch (e) {
              print('[TokenRefresh] Retry failed: $e');
              _isRefreshing = false;
              _rejectPendingRequests(err);
              return handler.next(err);
            }
          } else {
            print(
              '[TokenRefresh] Refresh response invalid: ${data['message'] ?? 'Unknown error'}',
            );
          }
        } else {
          print(
            '[TokenRefresh] Refresh failed with status: ${response.statusCode}',
          );
        }

        // Refresh failed - clear token and reject
        await prefs.remove('jwt_token');
        _isRefreshing = false;
        _rejectPendingRequests(err);
        return handler.next(err);
      } catch (e) {
        // Refresh failed - clear token
        print('[TokenRefresh] Exception during refresh: $e');
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('jwt_token');

        _isRefreshing = false;
        _rejectPendingRequests(err);
        return handler.next(err);
      }
    }

    // Not a 401 error, pass through
    return handler.next(err);
  }

  void _resolvePendingRequests(String newToken) {
    for (final pending in _pendingRequests) {
      final opts = pending.options.copyWith(
        headers: {...pending.options.headers, 'Authorization': newToken},
      );

      _refreshDio
          .fetch(opts)
          .then((response) {
            pending.handler.resolve(
              Response(
                data: response.data,
                statusCode: response.statusCode,
                statusMessage: response.statusMessage,
                requestOptions: pending.options,
              ),
            );
          })
          .catchError((error) {
            pending.handler.reject(
              DioException(requestOptions: pending.options, error: error),
            );
          });
    }
    _pendingRequests.clear();
  }

  void _rejectPendingRequests(DioException error) {
    for (final pending in _pendingRequests) {
      pending.handler.reject(error);
    }
    _pendingRequests.clear();
  }
}
