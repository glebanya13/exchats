import 'dart:async';
import '../repository/user_repository.dart';
import '../entity/user_entity.dart';

class UserUseCase {
  final UserRepository _userRepository;

  UserUseCase(this._userRepository);

  Future<UserEntity?> getUserById(String id) {
    return _userRepository.getUserById(id);
  }

  Future<UserEntity> createUser(UserEntity user) {
    return _userRepository.createUser(user);
  }

  Future<UserEntity> updateUser(UserEntity user) {
    return _userRepository.updateUser(user);
  }

  Future<void> updateOnlineStatus(String id, bool online) {
    return _userRepository.updateOnlineStatus(id, online);
  }

  Future<List<String>> getUserChats(String userId) {
    return _userRepository.getUserChats(userId);
  }

  Stream<UserEntity?> watchUser(String id) {
    return _userRepository.watchUser(id);
  }
}

