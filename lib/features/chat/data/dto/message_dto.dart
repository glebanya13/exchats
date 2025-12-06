final class MessageDto {
  final int id;
  final String type;
  final String? fileName;
  final Map<String, dynamic>? metadata;
  final int? userId;
  final DateTime insertedAt;
  final String content;
  final DateTime? editedAt;
  final bool encrypted;
  final String? fileUrl;
  final String? guestName;
  final Map<String, dynamic>? replyTo;

  MessageDto({
    required this.id,
    required this.type,
    this.fileName,
    this.metadata,
    this.userId,
    required this.insertedAt,
    required this.content,
    this.editedAt,
    required this.encrypted,
    this.fileUrl,
    this.guestName,
    this.replyTo,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json, {int? id}) {
    final rawId = id ?? json['id'];
    final normalizedId = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0;

    return MessageDto(
      id: normalizedId,
      type: json['type'] as String? ?? 'text',
      fileName: json['file_name'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      userId: json['user_id'] as int?,
      insertedAt: DateTime.parse(json['inserted_at'] as String),
      content: json['content'] as String? ?? '',
      editedAt: json['edited_at'] != null
          ? DateTime.tryParse(json['edited_at'] as String)
          : null,
      encrypted: json['encrypted'] as bool? ?? false,
      fileUrl: json['file_url'] as String?,
      guestName: json['guest_name'] as String?,
      replyTo: json['reply_to'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      if (fileName != null) 'file_name': fileName,
      if (metadata != null) 'metadata': metadata,
      if (userId != null) 'user_id': userId,
      'inserted_at': insertedAt.toIso8601String(),
      'content': content,
      if (editedAt != null) 'edited_at': editedAt!.toIso8601String(),
      'encrypted': encrypted,
      if (fileUrl != null) 'file_url': fileUrl,
      if (guestName != null) 'guest_name': guestName,
      if (replyTo != null) 'reply_to': replyTo,
    };
  }
}
