class ChatEntity {
  final String id;
  final String type;
  final int messageCounter;
  final bool historyCleared;
  final List<String> users;

  ChatEntity({
    required this.id,
    required this.type,
    required this.messageCounter,
    required this.historyCleared,
    required this.users,
  });
}

