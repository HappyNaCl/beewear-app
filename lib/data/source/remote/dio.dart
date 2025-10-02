import 'package:beewear_app/data/source/local/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = TokenStorage();

  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env["API_URL"] ?? "",
    connectTimeout: const Duration(seconds: 5),
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final accessToken = await storage.getAccessToken();
      if (accessToken != null) {
        options.headers["Authorization"] = "Bearer $accessToken";
      }
      return handler.next(options);
    },
    onError: (DioException e, handler) async {
      if (e.response?.statusCode == 401) {
        final refreshToken = await storage.getRefreshToken();
        if (refreshToken != null) {
          try {
            final refreshResponse = await dio.post(
              "/auth/refresh",
              data: {"refresh_token": refreshToken},
            );

            final newAccess = refreshResponse.data["access_token"];
            final newRefresh = refreshResponse.data["refresh_token"];

            await storage.saveTokens(newAccess, newRefresh);

            final retryOptions = e.requestOptions;
            retryOptions.headers["Authorization"] = "Bearer $newAccess";

            final cloneResponse = await dio.fetch(retryOptions);
            return handler.resolve(cloneResponse);
          } catch (err) {
            await storage.clear();
          }
        }
      }
      return handler.next(e);
    },
  ));

  return dio;
});
