import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import '../../domain/usecase/user_usecase.dart';
import '../../domain/entity/user_entity.dart';
import '../../../../core/util/phone_number_mask.dart';

part 'user_store.g.dart';

@lazySingleton
final class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final UserUseCase _userUseCase;

  _UserStore(this._userUseCase) {
    _setupUserWatcher();
  }

  @observable
  UserEntity? user;

  @observable
  String? formattedPhoneNumber;

  @observable
  bool isLoading = false;

  @observable
  String? error;

  StreamSubscription<UserEntity?>? _userSubscription;

  void _setupUserWatcher() {
    formattedPhoneNumber = '';
  }

  @action
  void watchUser(String userId) {
    _userSubscription?.cancel();
    _userSubscription = _userUseCase.watchUser(userId).listen((user) {
      if (user != null) {
        this.user = user;
        formatPhoneNumber(user.phone);
      }
    });

    _loadUser(userId);
  }

  @action
  Future<UserEntity?> getUserById(String id) async {
    isLoading = true;
    error = null;
    try {
      final user = await _userUseCase.getUserById(id);
      if (user != null && this.user?.id == id) {
        this.user = user;
      }
      return user;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _loadUser(String userId) async {
    isLoading = true;
    error = null;
    try {
      final loadedUser = await _userUseCase.getUserById(userId);
      if (loadedUser != null) {
        user = loadedUser;
        formatPhoneNumber(loadedUser.phone);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> formatPhoneNumber(String phoneNumber) async {
    formattedPhoneNumber = PhoneNumberMask.format(
      text: phoneNumber,
      mask: '+# ### ### ## ##',
    );
  }

  @action
  Future<UserEntity?> updateProfile({
    required String name,
    required String username,
    String? avatarUrl,
  }) async {
    if (user == null) return null;
    isLoading = true;
    error = null;
    try {
      final entity = user!.copyWith(
        name: name,
        username: username,
        avatarUrl: avatarUrl ?? user!.avatarUrl,
      );
      final updated = await _userUseCase.updateUser(entity);
      user = updated;
      await formatPhoneNumber(updated.phone);
      return updated;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  void dispose() {
    _userSubscription?.cancel();
  }
}
