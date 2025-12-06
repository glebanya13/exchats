import '../../../user/data/dto/user_dto.dart';
import 'message_dto.dart';
import 'room_participant_dto.dart';

final class RoomDto {
  final int id;
  final String? name;
  final UserDto owner;
  final String type; // 'private' | 'group'
  final MessageDto? lastMessage;
  final List<RoomParticipantDto> participants;
  final DateTime insertedAt;
  final DateTime updatedAt;
  final bool encryptionEnabled;
  final String? inviteToken;
  final int unreadCount;

  RoomDto({
    required this.id,
    this.name,
    required this.owner,
    required this.type,
    this.lastMessage,
    required this.participants,
    required this.insertedAt,
    required this.updatedAt,
    required this.encryptionEnabled,
    this.inviteToken,
    required this.unreadCount,
  });

  factory RoomDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final normalizedId = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0;

    return RoomDto(
      id: normalizedId,
      name: json['name'] as String?,
      owner: UserDto.fromJson(json['owner'] as Map<String, dynamic>),
      type: json['type'] as String? ?? 'private',
      lastMessage: json['last_message'] != null
          ? MessageDto.fromJson(json['last_message'] as Map<String, dynamic>)
          : null,
      participants: (json['participants'] as List<dynamic>?)
              ?.map((p) => RoomParticipantDto.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      insertedAt: DateTime.parse(json['inserted_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      encryptionEnabled: json['encryption_enabled'] as bool? ?? false,
      inviteToken: json['invite_token'] as String?,
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      'owner': owner.toJson(),
      'type': type,
      if (lastMessage != null) 'last_message': lastMessage!.toJson(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'inserted_at': insertedAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'encryption_enabled': encryptionEnabled,
      if (inviteToken != null) 'invite_token': inviteToken,
      'unread_count': unreadCount,
    };
  }
}

