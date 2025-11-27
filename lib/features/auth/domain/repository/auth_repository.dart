import '../../../../features/user/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<void> sendVerificationCode(String phoneNumber);
  Future<UserEntity> verifyCode({
    required String phoneNumber,
    required String code,
  });
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
