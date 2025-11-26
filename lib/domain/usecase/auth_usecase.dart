import '../repository/auth_repository.dart';
import '../entity/user_entity.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<String> sendVerificationCode(String phoneNumber) {
    return _authRepository.sendVerificationCode(phoneNumber);
  }

  Future<UserEntity> verifyCode({
    required String phoneNumber,
    required String code,
  }) {
    return _authRepository.verifyCode(
      phoneNumber: phoneNumber,
      code: code,
    );
  }

  Future<void> logout() {
    return _authRepository.logout();
  }

  Future<String?> getCurrentUserId() {
    return _authRepository.getCurrentUserId();
  }
}

