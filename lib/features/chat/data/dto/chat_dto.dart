class ChatDto {
  final String id;
  final String type;
  final int messageCounter;
  final bool historyCleared;
  final List<String> users;

  ChatDto({
    required this.id,
    required this.type,
    required this.messageCounter,
    required this.historyCleared,
    required this.users,
  });

  factory ChatDto.fromJson(Map<String, dynamic> json, {String? id}) {
    return ChatDto(
      id: id ?? json['id'] as String? ?? '',
      type: json['type'] as String,
      messageCounter: json['message_counter'] as int? ?? 0,
      historyCleared: json['history_cleared'] as bool? ?? false,
      users: List<String>.from(json['users'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'message_counter': messageCounter,
      'history_cleared': historyCleared,
      'users': users,
    };
  }
}
