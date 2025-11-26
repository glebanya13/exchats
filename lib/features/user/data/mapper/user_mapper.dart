import '../dto/user_dto.dart';
import '../../domain/entity/user_entity.dart';

class UserMapper {
  static UserEntity toEntity(UserDto dto) {
    return UserEntity(
      id: dto.id,
      username: dto.username,
      firstName: dto.firstName,
      lastName: dto.lastName,
      phoneNumber: dto.phoneNumber,
      online: dto.online,
      chats: dto.chats,
    );
  }

  static UserDto toDto(UserEntity entity) {
    return UserDto(
      id: entity.id,
      username: entity.username,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phoneNumber: entity.phoneNumber,
      online: entity.online,
      chats: entity.chats,
    );
  }
}

