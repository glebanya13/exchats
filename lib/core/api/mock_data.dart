import '../../features/user/data/dto/user_dto.dart';
import '../../features/chat/data/dto/chat_dto.dart';
import '../../features/chat/data/dto/message_dto.dart';

class MockData {
  static const String currentUserId = 'user1';

  static final Map<String, UserDto> users = {
    'user1': UserDto(
      id: 'user1',
      name: 'John Doe',
      username: 'john_doe',
      phone: '+1234567890',
      email: 'john@example.com',
      avatarUrl: '',
      insertedAt: DateTime.now().subtract(const Duration(days: 5)),
      lastSeenAt: DateTime.now(),
      chats: ['chat1', 'chat2', 'chat3', 'chat4', 'chat5', 'chat6', 'chat7'],
    ),
    'user2': UserDto(
      id: 'user2',
      name: 'Артём',
      username: 'artem',
      phone: '+0987654321',
      email: 'artem@example.com',
      avatarUrl: '',
      insertedAt: DateTime.now().subtract(const Duration(days: 10)),
      lastSeenAt: DateTime.now(),
      chats: ['chat3'],
    ),
    'user3': UserDto(
      id: 'user3',
      name: 'Валерий',
      username: 'valery',
      phone: '+1122334455',
      email: 'valery@example.com',
      avatarUrl: '',
      insertedAt: DateTime.now().subtract(const Duration(days: 7)),
      lastSeenAt: DateTime.now().subtract(const Duration(hours: 1)),
      chats: ['chat1'],
    ),
    'user4': UserDto(
      id: 'user4',
      name: 'Мария',
      username: 'maria',
      phone: '+5566778899',
      email: 'maria@example.com',
      avatarUrl: '',
      insertedAt: DateTime.now().subtract(const Duration(days: 2)),
      lastSeenAt: DateTime.now(),
      chats: ['chat2'],
    ),
  };

  static final Map<String, ChatDto> chats = {
    'chat1': ChatDto(
      id: 'chat1',
      type: 'dialog',
      messageCounter: 5,
      historyCleared: false,
      users: ['user1', 'user2'],
    ),
    'chat2': ChatDto(
      id: 'chat2',
      type: 'group',
      messageCounter: 12,
      historyCleared: false,
      users: ['user1', 'user2', 'user3', 'user4'],
    ),
  };

  static final Map<String, List<MessageDto>> messages = {
    'chat1': [],
    'chat2': [],
  };
}
