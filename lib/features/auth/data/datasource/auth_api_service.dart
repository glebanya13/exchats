import 'package:dio/dio.dart';
import 'package:exchats/core/api/api_provider.dart';
import 'package:exchats/features/auth/data/dto/auth_tokens_dto.dart';
import 'package:exchats/features/auth/data/dto/register_request_dto.dart';
import 'package:exchats/features/auth/data/dto/refresh_request_dto.dart';
import 'package:exchats/features/auth/data/dto/verify_request_dto.dart';
import 'package:exchats/features/user/data/dto/user_dto.dart';

class AuthApiService {
  final ApiProvider _apiProvider;

  AuthApiService(this._apiProvider);

  Future<void> requestSmsCode(String phoneNumber) async {
    final body = RegisterRequestDto(phone: phoneNumber);
    await _apiProvider.post<void>(
      '/api/auth/register',
      data: body.toJson(),
    );
  }

  Future<AuthTokensDto> verifyCode({
    required String phoneNumber,
    required String code,
  }) async {
    final request = VerifyRequestDto(phone: phoneNumber, code: code);
    final response = await _apiProvider.post<Map<String, dynamic>>(
      '/api/auth/verify',
      data: request.toJson(),
    );
    return AuthTokensDto.fromJson(response.data);
  }

  Future<AuthTokensDto> refreshToken(String refreshToken) async {
    final body = RefreshRequestDto(refreshToken: refreshToken);
    final response = await _apiProvider.post<Map<String, dynamic>>(
      '/api/auth/refresh',
      data: body.toJson(),
    );
    return AuthTokensDto.fromJson(response.data);
  }

  Future<UserDto> getCurrentUser() async {
    final response = await _apiProvider.get<Map<String, dynamic>>(
      '/api/auth/me',
    );
    final raw = response.data ?? <String, dynamic>{};
    final data = raw['data'] is Map<String, dynamic>
        ? raw['data'] as Map<String, dynamic>
        : raw;
    return UserDto.fromJson(data);
  }

  Future<void> logout() async {
    try {
      await _apiProvider.post<void>('/api/auth/logout');
    } on DioException catch (_) {
      // swallow network errors during logout to avoid blocking local cleanup
    }
  }
}
