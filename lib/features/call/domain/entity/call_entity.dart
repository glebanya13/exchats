class CallEntity {
  final String id;
  final String userId;
  final String userName;
  final String type;
  final DateTime date;

  CallEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.date,
  });

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      final hours = date.hour;
      final minutes = date.minute;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}

class CallType {
  static const String Missed = 'missed';
  static const String Incoming = 'incoming';
  static const String Outgoing = 'outgoing';
}
