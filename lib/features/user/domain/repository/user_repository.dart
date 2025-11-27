import '../entity/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getUserById(String id);
  Future<UserEntity> createUser(UserEntity user);
  Future<UserEntity> updateUser(UserEntity user);
  Future<List<String>> getUserChats(String userId);
  Stream<UserEntity?> watchUser(String id);
}
