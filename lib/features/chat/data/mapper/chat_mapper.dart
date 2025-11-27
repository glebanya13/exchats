import '../dto/chat_dto.dart';
import '../../domain/entity/chat_entity.dart';

class ChatMapper {
  static ChatEntity toEntity(ChatDto dto) {
    return ChatEntity(
      id: dto.id,
      type: dto.type,
      messageCounter: dto.messageCounter,
      historyCleared: dto.historyCleared,
      users: dto.users,
    );
  }

  static ChatDto toDto(ChatEntity entity) {
    return ChatDto(
      id: entity.id,
      type: entity.type,
      messageCounter: entity.messageCounter,
      historyCleared: entity.historyCleared,
      users: entity.users,
    );
  }
}
