import 'package:injectable/injectable.dart';

import '../repository/auth_repository.dart';
import '../../../../features/user/domain/entity/user_entity.dart';

@lazySingleton
final class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<void> sendVerificationCode(String phoneNumber) {
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

  Future<UserEntity?> getCurrentUser() {
    return _authRepository.getCurrentUser();
  }
}
