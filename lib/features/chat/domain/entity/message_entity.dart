final class MessageEntity {
  final String id; // converted from int
  final String type;
  final String? fileName;
  final Map<String, dynamic>? metadata;
  final String? userId; // converted from int
  final DateTime insertedAt;
  final String content;
  final DateTime? editedAt;
  final bool encrypted;
  final String? fileUrl;
  final String? guestName;
  final Map<String, dynamic>? replyTo;

  MessageEntity({
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

  // Helper getters for backward compatibility
  String get text => content;
  DateTime get createdAt => insertedAt;
  DateTime get updatedAt => editedAt ?? insertedAt;
  bool get edited => editedAt != null;
  String? get owner => userId;
  bool get read => true; // TODO: implement read status from participants
  Duration? get callDuration => null; // TODO: extract from metadata if needed
  List<String>? get participants => null; // TODO: extract from metadata if needed
}
