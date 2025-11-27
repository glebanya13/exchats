import '../constants/app_strings.dart';

class LastSeenFormatter {
  static const _months = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  static bool isOnline(DateTime? lastSeen,
      {Duration threshold = const Duration(minutes: 5)}) {
    if (lastSeen == null) return false;
    final now = DateTime.now();
    return now.difference(lastSeen) <= threshold;
  }

  static String format(DateTime? lastSeen) {
    if (lastSeen == null) return AppStrings.unknown;
    final now = DateTime.now();
    final time =
        '${lastSeen.hour.toString().padLeft(2, '0')}:${lastSeen.minute.toString().padLeft(2, '0')}';

    if (_isSameDay(now, lastSeen)) {
      return 'Был(а) в $time';
    }

    if (now.year == lastSeen.year) {
      final month = _months[lastSeen.month - 1];
      return 'Был(а) ${lastSeen.day} $month в $time';
    }

    final month = _months[lastSeen.month - 1];
    return 'Был(а) ${lastSeen.day} $month ${lastSeen.year} в $time';
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
