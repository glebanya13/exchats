import 'package:mobx/mobx.dart';
import '../../domain/usecase/auth_usecase.dart';
import '../../../../features/user/domain/entity/user_entity.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthUseCase _authUseCase;

  _AuthStore(this._authUseCase);

  @observable
  String? currentUserId;

  @observable
  UserEntity? currentUser;

  @observable
  bool isAuthenticated = false;

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  Future<void> checkAuthStatus() async {
    isLoading = true;
    error = null;
    try {
      final userId = await _authUseCase.getCurrentUserId();
      if (userId != null) {
        currentUserId = userId;
        isAuthenticated = true;
      } else {
        isAuthenticated = false;
        currentUserId = null;
      }
    } catch (e) {
      error = e.toString();
      isAuthenticated = false;
      currentUserId = null;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<String> sendVerificationCode(String phoneNumber) async {
    isLoading = true;
    error = null;
    try {
      final verificationId = await _authUseCase.sendVerificationCode(phoneNumber);
      return verificationId;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> verifyCode({
    required String phoneNumber,
    required String code,
  }) async {
    isLoading = true;
    error = null;
    try {
      final user = await _authUseCase.verifyCode(
        phoneNumber: phoneNumber,
        code: code,
      );
      currentUser = user;
      currentUserId = user.id;
      isAuthenticated = true;
    } catch (e) {
      error = e.toString();
      isAuthenticated = false;
      currentUserId = null;
      currentUser = null;
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    isLoading = true;
    error = null;
    try {
      await _authUseCase.logout();
      isAuthenticated = false;
      currentUserId = null;
      currentUser = null;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
