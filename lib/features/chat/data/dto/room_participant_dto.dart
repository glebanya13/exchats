import '../../../user/data/dto/user_dto.dart';

final class RoomParticipantDto {
  final int id;
  final UserDto user;
  final DateTime? lastReadAt;
  final DateTime? seenAt;

  RoomParticipantDto({
    required this.id,
    required this.user,
    this.lastReadAt,
    this.seenAt,
  });

  factory RoomParticipantDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final normalizedId = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0;

    return RoomParticipantDto(
      id: normalizedId,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      lastReadAt: json['last_read_at'] != null
          ? DateTime.tryParse(json['last_read_at'] as String)
          : null,
      seenAt: json['seen_at'] != null
          ? DateTime.tryParse(json['seen_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      if (lastReadAt != null) 'last_read_at': lastReadAt!.toIso8601String(),
      if (seenAt != null) 'seen_at': seenAt!.toIso8601String(),
    };
  }
}

