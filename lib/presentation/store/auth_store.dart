import 'package:mobx/mobx.dart';
import '../../domain/usecase/auth_usecase.dart';
import '../../domain/entity/user_entity.dart';

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
  bool isLoading = false;

  @observable
  String? error;

  @computed
  bool get isAuthenticated => currentUserId != null;

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
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    isLoading = true;
    try {
      await _authUseCase.logout();
      currentUserId = null;
      currentUser = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> checkAuthStatus() async {
    currentUserId = await _authUseCase.getCurrentUserId();
  }
}

