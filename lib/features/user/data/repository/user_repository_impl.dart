import 'dart:async';
import '../../domain/repository/user_repository.dart';
import '../../domain/entity/user_entity.dart';
import '../../../../core/api/api_service.dart';
import '../mapper/user_mapper.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;
  final Map<String, StreamController<UserEntity?>> _userStreams = {};

  UserRepositoryImpl(this._apiService);

  @override
  Future<UserEntity?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (id == 'user2') {
      return UserEntity(
        id: 'user2',
        username: 'artem',
        firstName: 'Артём',
        lastName: '',
        phoneNumber: '+0987654321',
        online: true,
        chats: [],
      );
    } else if (id == 'user3') {
      return UserEntity(
        id: 'user3',
        username: 'valery',
        firstName: 'Валерий',
        lastName: '',
        phoneNumber: '+1122334455',
        online: false,
        chats: [],
      );
    } else if (id == 'user4') {
      return UserEntity(
        id: 'user4',
        username: 'maria',
        firstName: 'Мария',
        lastName: '',
        phoneNumber: '+5566778899',
        online: true,
        chats: [],
      );
    }
    
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
    final userDto = UserMapper.toDto(user);
    final updatedDto = await _apiService.updateUser(user.id, userDto);
    return UserMapper.toEntity(updatedDto);
  }

  @override
  Future<void> updateOnlineStatus(String id, bool online) async {
    await _apiService.updateOnlineStatus(id, online);
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
