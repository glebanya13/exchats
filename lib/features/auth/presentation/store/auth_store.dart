import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import '../../domain/usecase/auth_usecase.dart';
import '../../../../features/user/domain/entity/user_entity.dart';

part 'auth_store.g.dart';

@lazySingleton
final class AuthStore = _AuthStore with _$AuthStore;

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
      final user = await _authUseCase.getCurrentUser();
      if (user != null) {
        currentUser = user;
        currentUserId = user.id;
        isAuthenticated = true;
      } else {
        currentUser = null;
        currentUserId = null;
        isAuthenticated = false;
      }
    } catch (e) {
      error = e.toString();
      isAuthenticated = false;
      currentUserId = null;
      currentUser = null;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> sendVerificationCode(String phoneNumber) async {
    isLoading = true;
    error = null;
    try {
      await _authUseCase.sendVerificationCode(phoneNumber);
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

  @action
  void updateCurrentUser(UserEntity user) {
    currentUser = user;
    currentUserId = user.id;
    isAuthenticated = true;
  }
}
