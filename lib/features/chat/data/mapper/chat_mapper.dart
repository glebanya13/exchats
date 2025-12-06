import '../dto/room_dto.dart';
import '../../domain/entity/chat_entity.dart';
import '../../../user/data/mapper/user_mapper.dart';
import 'message_mapper.dart';

final class ChatMapper {
  static ChatEntity toEntity(RoomDto dto) {
    return ChatEntity(
      id: dto.id.toString(),
      name: dto.name,
      owner: UserMapper.toEntity(dto.owner),
      type: dto.type,
      lastMessage: dto.lastMessage != null
          ? MessageMapper.toEntity(dto.lastMessage!)
          : null,
      participantUserIds: dto.participants.map((p) => p.user.id).toList(),
      insertedAt: dto.insertedAt,
      updatedAt: dto.updatedAt,
      encryptionEnabled: dto.encryptionEnabled,
      inviteToken: dto.inviteToken,
      unreadCount: dto.unreadCount,
    );
  }
}
