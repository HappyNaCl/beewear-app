import 'package:beewear_app/data/source/local/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = TokenStorage();

  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env["API_URL"] ?? "",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final startTime = DateTime.now();
        debugPrint('🌐 [DIO] ${options.method} ${options.path} - Starting...');

        final accessToken = await storage.getAccessToken();
        if (accessToken != null) {
          options.headers["Authorization"] = "Bearer $accessToken";
          debugPrint('🔑 [DIO] Added access token to request');
        } else {
          debugPrint('⚠️ [DIO] No access token available');
        }

        options.extra['startTime'] = startTime;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        final startTime =
            response.requestOptions.extra['startTime'] as DateTime?;
        if (startTime != null) {
          final duration = DateTime.now().difference(startTime);
          debugPrint(
            '✅ [DIO] ${response.requestOptions.method} ${response.requestOptions.path} - Success (${duration.inMilliseconds}ms)',
          );
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        final startTime = e.requestOptions.extra['startTime'] as DateTime?;
        if (startTime != null) {
          final duration = DateTime.now().difference(startTime);
          debugPrint(
            '❌ [DIO] ${e.requestOptions.method} ${e.requestOptions.path} - Error (${duration.inMilliseconds}ms): ${e.message}',
          );
        }

        // Skip token refresh logic for /auth/refresh endpoint to prevent infinite loop
        if (e.requestOptions.path.contains('/auth/refresh')) {
          debugPrint('⚠️ [DIO] Refresh endpoint failed, skipping retry');
          return handler.next(e);
        }

        if (e.response?.statusCode == 401) {
          debugPrint('🔄 [DIO] Got 401, attempting token refresh...');
          final refreshToken = await storage.getRefreshToken();
          if (refreshToken != null) {
            try {
              debugPrint('🔄 [DIO] Calling /auth/refresh...');
              final refreshStart = DateTime.now();

              // Create a new Dio instance without interceptors for the refresh call
              final refreshDio = Dio(dio.options);
              final refreshResponse = await refreshDio.post(
                "/auth/refresh",
                data: {"refresh_token": refreshToken},
              );

              final refreshDuration = DateTime.now().difference(refreshStart);
              debugPrint(
                '✅ [DIO] Token refresh successful (${refreshDuration.inMilliseconds}ms)',
              );

              final newAccess = refreshResponse.data["data"]["access_token"];
              final newRefresh = refreshResponse.data["data"]["refresh_token"];

              await storage.saveTokens(newAccess, newRefresh);
              debugPrint(
                '✅ [DIO] New tokens saved, retrying original request...',
              );

              final retryOptions = e.requestOptions;
              retryOptions.headers["Authorization"] = "Bearer $newAccess";

              final retryStart = DateTime.now();
              final cloneResponse = await dio.fetch(retryOptions);
              final retryDuration = DateTime.now().difference(retryStart);
              debugPrint(
                '✅ [DIO] Retry successful (${retryDuration.inMilliseconds}ms)',
              );

              return handler.resolve(cloneResponse);
            } catch (err) {
              debugPrint('❌ [DIO] Token refresh failed: $err');
              await storage.clear();
            }
          } else {
            debugPrint('⚠️ [DIO] No refresh token available');
          }
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
});
