import '../../features/user/data/dto/user_dto.dart';
import '../../features/chat/data/dto/chat_dto.dart';
import '../../features/chat/data/dto/message_dto.dart';

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
      chats: ['chat1'],
    ),
    'user4': UserDto(
      id: 'user4',
      username: 'maria',
      firstName: 'Мария',
      lastName: '',
      phoneNumber: '+5566778899',
      online: true,
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
