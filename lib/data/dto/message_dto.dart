class MessageDto {
  final String id;
  final String owner;
  final String text;
  final String createdAt;
  final String updatedAt;
  final bool edited;
  final bool read;
  final String? replyTo;
  final String type;
  final int? callDuration;
  final List<String>? participants;

  MessageDto({
    required this.id,
    required this.owner,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.edited,
    required this.read,
    this.replyTo,
    this.type = 'text',
    this.callDuration,
    this.participants,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json, {String? id}) {
    return MessageDto(
      id: id ?? json['id'] as String? ?? '',
      owner: json['owner'] as String,
      text: json['text'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      edited: json['edited'] as bool? ?? false,
      read: json['read'] as bool? ?? false,
      replyTo: json['reply_to'] as String?,
      type: json['type'] as String? ?? 'text',
      callDuration: json['call_duration'] as int?,
      participants: json['participants'] != null
          ? List<String>.from(json['participants'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner,
      'text': text,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'edited': edited,
      'read': read,
      if (replyTo != null) 'reply_to': replyTo,
      'type': type,
      if (callDuration != null) 'call_duration': callDuration,
      if (participants != null) 'participants': participants,
    };
  }
}

