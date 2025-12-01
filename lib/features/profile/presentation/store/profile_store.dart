import 'package:exchats/features/auth/domain/usecase/auth_usecase.dart';
import 'package:exchats/features/user/domain/entity/user_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'profile_store.g.dart';

@lazySingleton
final class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final AuthUseCase _authUseCase;

  _ProfileStore(this._authUseCase);

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
  Future<void> getCurrentUser() async {
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
