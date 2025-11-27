class MessageEntity {
  final String id;
  final String owner;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool edited;
  final bool read;
  final String? replyTo;
  final String type;
  final Duration? callDuration;
  final List<String>? participants;

  MessageEntity({
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
}
