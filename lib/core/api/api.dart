import 'package:dio/dio.dart';
import 'package:exchats/core/services/secure_storage/token_repository.dart';
import 'package:exchats/env.dart';

import '../../features/auth/data/dto/dto.dart';
import '../../features/auth/data/mappers/mappers.dart';

class Api {
  static const _skipAuthKey = 'skipAuth';

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: Duration(seconds: Env.connectTimeout),
        receiveTimeout: Duration(seconds: Env.receiveTimeout),
        sendTimeout: Duration(seconds: Env.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final skipAuth = options.extra[_skipAuthKey] == true;
          if (!skipAuth) {
            final token = await TokenRepository.getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          final skipAuth = error.requestOptions.extra[_skipAuthKey] == true;
          if (skipAuth) {
            return handler.next(error);
          }
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final opts = error.requestOptions;
              final token = await TokenRepository.getAccessToken();
              if (token != null) {
                opts.headers['Authorization'] = 'Bearer $token';
                try {
                  final response = await dio.fetch(opts);
                  return handler.resolve(response);
                } catch (e) {
                  return handler.next(error);
                }
              }
            }
            await TokenRepository.deleteAll();
          }
          return handler.next(error);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
    return dio;
  }

  static Future<bool> _refreshToken() async {
    try {
      final refreshToken = await TokenRepository.getRefreshToken();
      if (refreshToken == null) return false;

      final tokenDio = Dio(
        BaseOptions(
          baseUrl: Env.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await tokenDio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(extra: const {_skipAuthKey: true}),
      );

      if (response.statusCode == 200) {
        final dto = AuthTokensDto.fromJson(response.data);
        final entity = AuthTokensMapper.toEntity(from: dto);
        final newAccessToken = entity.accessToken;
        if (newAccessToken.isEmpty) {
          return false;
        }
        await TokenRepository.saveTokens(
          accessToken: newAccessToken,
          refreshToken: entity.refreshToken,
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
