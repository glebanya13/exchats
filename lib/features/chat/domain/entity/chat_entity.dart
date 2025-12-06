import 'message_entity.dart';
import '../../../user/domain/entity/user_entity.dart';

final class ChatEntity {
  final String id; // converted from int
  final String? name;
  final UserEntity owner;
  final String type; // 'private' | 'group'
  final MessageEntity? lastMessage;
  final List<String> participantUserIds; // extracted from participants
  final DateTime insertedAt;
  final DateTime updatedAt;
  final bool encryptionEnabled;
  final String? inviteToken;
  final int unreadCount;

  ChatEntity({
    required this.id,
    this.name,
    required this.owner,
    required this.type,
    this.lastMessage,
    required this.participantUserIds,
    required this.insertedAt,
    required this.updatedAt,
    required this.encryptionEnabled,
    this.inviteToken,
    required this.unreadCount,
  });
}
