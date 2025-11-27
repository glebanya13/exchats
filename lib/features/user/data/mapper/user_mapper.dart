import '../dto/user_dto.dart';
import '../../domain/entity/user_entity.dart';

class UserMapper {
  static UserEntity toEntity(UserDto dto) {
    return UserEntity(
      id: dto.id,
      name: dto.name,
      username: dto.username,
      phone: dto.phone,
      email: dto.email,
      avatarUrl: dto.avatarUrl,
      insertedAt: dto.insertedAt,
      lastSeenAt: dto.lastSeenAt,
      chats: dto.chats,
    );
  }

  static UserDto toDto(UserEntity entity) {
    return UserDto(
      id: entity.id,
      name: entity.name,
      username: entity.username,
      phone: entity.phone,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      insertedAt: entity.insertedAt,
      lastSeenAt: entity.lastSeenAt,
      chats: entity.chats,
    );
  }
}
