import '../dto/message_dto.dart';
import '../../domain/entity/message_entity.dart';

class MessageMapper {
  static MessageEntity toEntity(MessageDto dto) {
    return MessageEntity(
      id: dto.id,
      owner: dto.owner,
      text: dto.text,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: DateTime.parse(dto.updatedAt),
      edited: dto.edited,
      read: dto.read,
      replyTo: dto.replyTo,
      type: dto.type,
      callDuration: dto.callDuration != null
          ? Duration(seconds: dto.callDuration!)
          : null,
      participants: dto.participants,
    );
  }

  static MessageDto toDto(MessageEntity entity) {
    return MessageDto(
      id: entity.id,
      owner: entity.owner,
      text: entity.text,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      edited: entity.edited,
      read: entity.read,
      replyTo: entity.replyTo,
      type: entity.type,
      callDuration: entity.callDuration?.inSeconds,
      participants: entity.participants,
    );
  }
}

