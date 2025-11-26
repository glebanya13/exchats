import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../domain/usecase/user_usecase.dart';
import '../../domain/entity/user_entity.dart';
import '../../../../core/util/phone_number_mask.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

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
        formatPhoneNumber(user.phoneNumber);
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
        formatPhoneNumber(loadedUser.phoneNumber);
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
  Future<void> updateOnlineStatus(bool online) async {
    if (user == null) return;
    
    isLoading = true;
    error = null;
    try {
      await _userUseCase.updateOnlineStatus(user!.id, online);
      user = UserEntity(
        id: user!.id,
        username: user!.username,
        firstName: user!.firstName,
        lastName: user!.lastName,
        phoneNumber: user!.phoneNumber,
        online: online,
        chats: user!.chats,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  void dispose() {
    _userSubscription?.cancel();
  }
}
