class CallType {
  static const String Incoming = 'incoming';
  static const String Outgoing = 'outgoing';
  static const String Missed = 'missed';
}

class Call {
  Call({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.date,
    this.isVideo = false,
    this.duration,
  });

  final String id;
  final String userId;
  final String userName;
  final String type; // incoming, outgoing, missed
  final DateTime date;
  final bool isVideo;
  final Duration? duration;

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final callDate = DateTime(date.year, date.month, date.day);

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final time = '$hour:$minute';

    if (callDate == today) {
      return time;
    } else if (callDate == yesterday) {
      return 'Вчера';
    } else {
      final months = [
        'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
        'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
      ];
      return '${date.day} ${months[date.month - 1]}, $time';
    }
  }
}

