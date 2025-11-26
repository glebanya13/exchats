import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/entity/user_entity.dart';
import '../api/api_service.dart';
import '../mapper/user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final SharedPreferences _prefs;

  AuthRepositoryImpl(this._apiService, this._prefs);

  @override
  Future<String> sendVerificationCode(String phoneNumber) async {
    final response = await _apiService.sendVerificationCode(phoneNumber);
    return response['verification_id'] as String;
  }

  @override
  Future<UserEntity> verifyCode({
    required String phoneNumber,
    required String code,
  }) async {
    final response = await _apiService.verifyCode(
      phoneNumber: phoneNumber,
      code: code,
    );
    

    final accessToken = response['access_token'] as String;
    final refreshToken = response['refresh_token'] as String;
    await _prefs.setString('access_token', accessToken);
    await _prefs.setString('refresh_token', refreshToken);
    

    final userId = response['user_id'] as String;
    await _prefs.setString('current_user_id', userId);
    

    final userDto = await _apiService.getUserById(userId);
    return UserMapper.toEntity(userDto);
  }

  @override
  Future<void> logout() async {
    await _prefs.remove('access_token');
    await _prefs.remove('refresh_token');
    await _prefs.remove('current_user_id');
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _prefs.getString('current_user_id');
  }
}

