import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../domain/usecase/user_usecase.dart';
import '../../domain/entity/user_entity.dart';
import '../../util/phone_number_mask.dart';

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
  Future<void> _loadUser(String userId) async {
    isLoading = true;
    try {
      user = await _userUseCase.getUserById(userId);
      if (user != null) {
        await formatPhoneNumber(user!.phoneNumber);
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
    try {
      await _userUseCase.updateOnlineStatus(user!.id, online);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> updateUser(UserEntity updatedUser) async {
    isLoading = true;
    try {
      user = await _userUseCase.updateUser(updatedUser);
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

