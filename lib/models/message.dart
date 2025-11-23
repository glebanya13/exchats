class MessageFields {
  static const String Owner = 'owner';
  static const String Text = 'text';
  static const String CreatedAt = 'created_at';
  static const String UpdatedAt = 'updated_at';
  static const String Edited = 'edited';
  static const String Read = 'read';
  static const String ReplyTo = 'reply_to';
  static const String Type = 'type';
}

class MessageType {
  static const String Text = 'text';
  static const String System = 'system';
  static const String Call = 'call';
  static const String VideoCall = 'video_call';
  static const String GroupCreated = 'group_created';
}

class Message {
  Message({
    required this.id,
    required this.owner,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.edited,
    required this.read,
    this.replyTo,
    this.type = MessageType.Text,
    this.callDuration,
    this.participants,
  });

  final String id;
  final String owner; // Changed from DocumentReference to String
  final String text;
  final DateTime createdAt; // Changed from Timestamp to DateTime
  final DateTime updatedAt; // Changed from Timestamp to DateTime
  final bool edited;
  final bool read;
  final String? replyTo; // ID сообщения, на которое отвечают
  final String type; // text, system, call, video_call, group_created
  final Duration? callDuration; // Для звонков
  final List<String>? participants; // Для звонков

  Message.fromJson(Map<String, dynamic> json, {String? id})
      : this(
          id: id ?? '',
          owner: json[MessageFields.Owner] as String,
          text: json[MessageFields.Text] as String,
          createdAt: json[MessageFields.CreatedAt] is DateTime
              ? json[MessageFields.CreatedAt] as DateTime
              : DateTime.now(),
          updatedAt: json[MessageFields.UpdatedAt] is DateTime
              ? json[MessageFields.UpdatedAt] as DateTime
              : DateTime.now(),
          edited: json[MessageFields.Edited] as bool? ?? false,
          read: json[MessageFields.Read] as bool? ?? false,
          replyTo: json[MessageFields.ReplyTo] as String?,
          type: json[MessageFields.Type] as String? ?? MessageType.Text,
          callDuration: json['call_duration'] != null
              ? Duration(seconds: json['call_duration'] as int)
              : null,
          participants: json['participants'] != null
              ? List<String>.from(json['participants'])
              : null,
        );

  Map<String, dynamic> toJson() {
    return {
      MessageFields.Owner: owner,
      MessageFields.Text: text,
      MessageFields.CreatedAt: createdAt.toIso8601String(),
      MessageFields.UpdatedAt: updatedAt.toIso8601String(),
      MessageFields.Edited: edited,
      MessageFields.Read: read,
      MessageFields.ReplyTo: replyTo,
      MessageFields.Type: type,
      if (callDuration != null) 'call_duration': callDuration!.inSeconds,
      if (participants != null) 'participants': participants,
    };
  }
}
