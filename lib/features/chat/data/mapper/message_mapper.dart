import '../dto/message_dto.dart';
import '../../domain/entity/message_entity.dart';

final class MessageMapper {
  static MessageEntity toEntity(MessageDto dto) {
    return MessageEntity(
      id: dto.id.toString(),
      type: dto.type,
      fileName: dto.fileName,
      metadata: dto.metadata,
      userId: dto.userId?.toString(),
      insertedAt: dto.insertedAt,
      content: dto.content,
      editedAt: dto.editedAt,
      encrypted: dto.encrypted,
      fileUrl: dto.fileUrl,
      guestName: dto.guestName,
      replyTo: dto.replyTo,
    );
  }

  static MessageDto toDto(MessageEntity entity) {
    return MessageDto(
      id: int.tryParse(entity.id) ?? 0,
      type: entity.type,
      fileName: entity.fileName,
      metadata: entity.metadata,
      userId: entity.userId != null ? int.tryParse(entity.userId!) : null,
      insertedAt: entity.insertedAt,
      content: entity.content,
      editedAt: entity.editedAt,
      encrypted: entity.encrypted,
      fileUrl: entity.fileUrl,
      guestName: entity.guestName,
      replyTo: entity.replyTo,
    );
  }
}
