import '../dto/user_dto.dart';
import '../dto/chat_dto.dart';
import '../dto/message_dto.dart';

class MockData {
  static const String currentUserId = 'user1';
  
  static final Map<String, UserDto> users = {
    'user1': UserDto(
      id: 'user1',
      username: 'john_doe',
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '+1234567890',
      online: true,
      chats: ['chat1', 'chat2', 'chat3', 'chat4', 'chat5', 'chat6', 'chat7'],
    ),
    'user2': UserDto(
      id: 'user2',
      username: 'artem',
      firstName: 'Артём',
      lastName: '',
      phoneNumber: '+0987654321',
      online: true,
      chats: ['chat3'],
    ),
    'user3': UserDto(
      id: 'user3',
      username: 'valery',
      firstName: 'Валерий',
      lastName: '',
      phoneNumber: '+1122334455',
      online: false,
      chats: ['chat2'],
    ),
    'user4': UserDto(
      id: 'user4',
      username: 'maria',
      firstName: 'Мария',
      lastName: '',
      phoneNumber: '+5566778899',
      online: true,
      chats: ['chat3'],
    ),
  };

  static final Map<String, ChatDto> chats = {
    'chat1': ChatDto(
      id: 'chat1',
      type: 'saved_messages',
      messageCounter: 0,
      historyCleared: false,
      users: ['user1'],
    ),
    'chat2': ChatDto(
      id: 'chat2',
      type: 'dialog',
      messageCounter: 3,
      historyCleared: false,
      users: ['user1', 'user3'],
    ),
    'chat3': ChatDto(
      id: 'chat3',
      type: 'group',
      messageCounter: 12,
      historyCleared: false,
      users: ['user1', 'user4', 'user2'],
    ),
    'chat4': ChatDto(
      id: 'chat4',
      type: 'dialog',
      messageCounter: 0,
      historyCleared: false,
      users: ['user1', 'user2'],
    ),
    'chat5': ChatDto(
      id: 'chat5',
      type: 'dialog',
      messageCounter: 5,
      historyCleared: false,
      users: ['user1', 'user4'],
    ),
    'chat6': ChatDto(
      id: 'chat6',
      type: 'group',
      messageCounter: 0,
      historyCleared: false,
      users: ['user1', 'user2', 'user3', 'user4'],
    ),
    'chat7': ChatDto(
      id: 'chat7',
      type: 'dialog',
      messageCounter: 1,
      historyCleared: false,
      users: ['user1', 'user3'],
    ),
  };

  static final Map<String, List<MessageDto>> messages = {
    'chat1': [
      MessageDto(
        id: 'msg1',
        owner: 'user1',
        text: 'Важная заметка для себя',
        createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        edited: false,
        read: true,
      ),
    ],
    'chat2': [
      MessageDto(
        id: 'msg4',
        owner: 'user3',
        text: 'Добрый день!',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        edited: false,
        read: false,
      ),
      MessageDto(
        id: 'msg5',
        owner: 'user1',
        text: 'Привет! Как настроение?',
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)).toIso8601String(),
        edited: false,
        read: false,
      ),
      MessageDto(
        id: 'msg6',
        owner: 'user3',
        text: 'Всё хорошо, спасибо!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
        edited: false,
        read: false,
      ),
    ],
    'chat3': [
      MessageDto(
        id: 'msg7',
        owner: 'user4',
        text: 'Привет! Ты видел новости?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
        edited: false,
        read: false,
      ),
      MessageDto(
        id: 'msg8',
        owner: 'user1',
        text: 'Да, видел! Очень интересно',
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 3)).toIso8601String(),
        edited: false,
        read: true,
      ),
      MessageDto(
        id: 'msg9',
        owner: 'user4',
        text: 'Согласен! 😊',
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 1)).toIso8601String(),
        edited: false,
        read: false,
      ),
    ],
    'chat4': [
      MessageDto(
        id: 'msg10',
        owner: 'user2',
        text: 'Привет! Как дела?',
        createdAt: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        edited: false,
        read: true,
      ),
    ],
    'chat5': [
      MessageDto(
        id: 'msg11',
        owner: 'user4',
        text: 'Спасибо за помощь!',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
        edited: false,
        read: false,
      ),
      MessageDto(
        id: 'msg12',
        owner: 'user1',
        text: 'Пожалуйста! Всегда рад помочь',
        createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 50)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 50)).toIso8601String(),
        edited: false,
        read: false,
      ),
      MessageDto(
        id: 'msg13',
        owner: 'user4',
        text: 'Можешь прислать файл?',
        createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)).toIso8601String(),
        edited: false,
        read: false,
      ),
      MessageDto(
        id: 'msg14',
        owner: 'user1',
        text: 'Конечно, сейчас отправлю',
        createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 20)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 20)).toIso8601String(),
        edited: false,
        read: false,
      ),
      MessageDto(
        id: 'msg15',
        owner: 'user4',
        text: 'Отлично, жду!',
        createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 15)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 15)).toIso8601String(),
        edited: false,
        read: false,
      ),
    ],
    'chat6': [
      MessageDto(
        id: 'msg16',
        owner: 'user2',
        text: 'Всем привет!',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)).toIso8601String(),
        edited: false,
        read: true,
      ),
    ],
    'chat7': [
      MessageDto(
        id: 'msg17',
        owner: 'user3',
        text: 'Напоминаю о встрече завтра в 10:00',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
        edited: false,
        read: false,
      ),
    ],
  };
}

