import 'package:dio/dio.dart';
import 'package:exchats/core/services/secure_storage/token_repository.dart';
import 'package:exchats/core/services/storage/local_user_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:exchats/features/auth/data/datasource/auth_api_service.dart';
import '../../domain/repository/auth_repository.dart';
import '../../../../features/user/domain/entity/user_entity.dart';
import '../../../../features/user/data/mapper/user_mapper.dart';
import '../mappers/auth_tokens_mapper.dart';

@LazySingleton(as: AuthRepository)
final class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  const AuthRepositoryImpl(this._authApiService);

  @override
  Future<void> sendVerificationCode(String phoneNumber) {
    return _authApiService.requestSmsCode(phoneNumber);
  }

  @override
  Future<UserEntity> verifyCode({
    required String phoneNumber,
    required String code,
  }) async {
    final response = await _authApiService.verifyCode(
      phoneNumber: phoneNumber,
      code: code,
    );
    final tokens = AuthTokensMapper.toEntity(from: response);
    if (tokens.accessToken.isEmpty) {
      throw Exception('Не удалось получить access token');
    }
    final refreshToken = tokens.refreshToken;
    if (refreshToken.isEmpty) {
      throw Exception('Не удалось получить refresh token');
    }

    TokenRepository.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: refreshToken,
    );

    final userDto = await _authApiService.getCurrentUser();
    LocalUserStorage.currentUserId = userDto.id;
    return UserMapper.toEntity(userDto);
  }

  @override
  Future<void> logout() async {
    await _authApiService.logout();
    await _clearStoredSession();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final userDto = await _authApiService.getCurrentUser();
      LocalUserStorage.currentUserId = userDto.id;
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
    await TokenRepository.deleteAll();
    LocalUserStorage.currentUserId = null;
  }
}
