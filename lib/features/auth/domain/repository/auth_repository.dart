import '../../../../features/user/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<String> sendVerificationCode(String phoneNumber);
  Future<UserEntity> verifyCode({
    required String phoneNumber,
    required String code,
  });
  Future<void> logout();
  Future<String?> getCurrentUserId();
}
