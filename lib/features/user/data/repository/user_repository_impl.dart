import 'dart:async';
import 'package:injectable/injectable.dart';

import '../../domain/repository/user_repository.dart';
import '../../domain/entity/user_entity.dart';
import '../../../../core/api/api_service.dart';
import '../mapper/user_mapper.dart';
import '../datasource/user_api_service.dart';
import '../dto/update_user_request_dto.dart';

@LazySingleton(as: UserRepository)
final class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;
  final UserApiService _userApiService;
  final Map<String, StreamController<UserEntity?>> _userStreams = {};

  UserRepositoryImpl(this._apiService, this._userApiService);

  @override
  Future<UserEntity?> getUserById(String id) async {
    try {
      final userDto = await _apiService.getUserById(id);
      return UserMapper.toEntity(userDto);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    final userDto = UserMapper.toDto(user);
    final createdDto = await _apiService.createUser(userDto);
    return UserMapper.toEntity(createdDto);
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    final request = UpdateUserRequestDto(
      name: user.name,
      username: user.username,
      avatarUrl: user.avatarUrl.isNotEmpty ? user.avatarUrl : null,
    );
    final updatedDto = await _userApiService.updateUser(
      id: user.id,
      body: request,
    );
    return UserMapper.toEntity(updatedDto);
  }

  @override
  Future<List<String>> getUserChats(String userId) async {
    final chats = await _apiService.getUserChats(userId);
    return chats.map((chat) => chat.id).toList();
  }

  @override
  Stream<UserEntity?> watchUser(String id) {
    if (!_userStreams.containsKey(id)) {
      final controller = StreamController<UserEntity?>.broadcast();
      _userStreams[id] = controller;

      Timer.periodic(const Duration(seconds: 5), (timer) async {
        if (controller.isClosed) {
          timer.cancel();
          return;
        }
        final user = await getUserById(id);
        controller.add(user);
      });

      getUserById(id).then((user) {
        if (!controller.isClosed) {
          controller.add(user);
        }
      });
    }
    return _userStreams[id]!.stream;
  }

  void dispose() {
    for (final controller in _userStreams.values) {
      controller.close();
    }
    _userStreams.clear();
  }
}
