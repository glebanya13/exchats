import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exchats/core/api/api_provider.dart';
import 'package:exchats/features/auth/data/datasource/auth_api_service.dart';
import '../../domain/repository/auth_repository.dart';
import '../../../../features/user/domain/entity/user_entity.dart';
import '../../../../features/user/data/mapper/user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final ApiProvider _apiProvider;
  final SharedPreferences _prefs;

  AuthRepositoryImpl(
    this._authApiService,
    this._apiProvider,
    this._prefs,
  );

  @override
  Future<void> sendVerificationCode(String phoneNumber) {
    return _authApiService.requestSmsCode(phoneNumber);
  }

  @override
  Future<UserEntity> verifyCode({
    required String phoneNumber,
    required String code,
  }) async {
    final tokens = await _authApiService.verifyCode(
      phoneNumber: phoneNumber,
      code: code,
    );
    if (tokens.accessToken.isEmpty) {
      throw Exception('Не удалось получить access token');
    }
    final refreshToken = tokens.refreshToken;
    if (refreshToken.isEmpty) {
      throw Exception('Не удалось получить refresh token');
    }

    await _apiProvider.setTokens(
      accessToken: tokens.accessToken,
      refreshToken: refreshToken,
    );
    await _prefs.setString('access_token', tokens.accessToken);
    await _prefs.setString('refresh_token', refreshToken);

    final userDto = await _authApiService.getCurrentUser();
    await _prefs.setString('current_user_id', userDto.id);
    return UserMapper.toEntity(userDto);
  }

  @override
  Future<void> logout() async {
    await _authApiService.logout();
    await _clearStoredSession();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final accessToken = _prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      await _clearStoredSession();
      return null;
    }
    try {
      final userDto = await _authApiService.getCurrentUser();
      await _prefs.setString('current_user_id', userDto.id);
      return UserMapper.toEntity(userDto);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _clearStoredSession();
        return null;
      }
      rethrow;
    }
  }

  Future<void> _clearStoredSession() async {
    await _apiProvider.clearTokens();
    await _prefs.remove('access_token');
    await _prefs.remove('refresh_token');
    await _prefs.remove('current_user_id');
  }
}
