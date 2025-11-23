import 'package:exchats/models/chat.dart';
import 'package:exchats/models/message.dart';
import 'package:exchats/models/user_details.dart';

class MockData {
  static const String currentUserId = 'user1';
  
  static final UserDetails currentUser = UserDetails(
    username: 'john_doe',
    firstName: 'John',
    lastName: 'Doe',
    phoneNumber: '+1234567890',
    online: true,
    chats: ['chat2', 'chat3'],
  );

  static final Map<String, UserDetails> users = {
    'user1': currentUser,
    'user2': UserDetails(
      username: 'artem',
      firstName: 'Артём',
      lastName: '',
      phoneNumber: '+0987654321',
      online: true,
      chats: ['chat3'],
    ),
    'user3': UserDetails(
      username: 'valery',
      firstName: 'Валерий',
      lastName: '',
      phoneNumber: '+1122334455',
      online: false,
      chats: ['chat2'],
    ),
    'user4': UserDetails(
      username: 'maria',
      firstName: 'Мария',
      lastName: '',
      phoneNumber: '+5566778899',
      online: true,
      chats: ['chat3'],
    ),
  };

  static final Map<String, Chat> chats = {
    'chat2': Chat(
      id: 'chat2',
      type: ChatType.Dialog,
      messageCounter: 8,
      historyCleared: false,
      users: ['user1', 'user3'],
    ),
    'chat3': Chat(
      id: 'chat3',
      type: ChatType.Group,
      messageCounter: 23,
      historyCleared: false,
      users: ['user1', 'user4', 'user2'],
    ),
  };

  static final Map<String, List<Message>> messages = {
    'chat2': [
      Message(
        id: 'msg4',
        owner: 'user3',
        text: 'Добрый день!',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
        edited: false,
        read: true,
      ),
      Message(
        id: 'msg5',
        owner: 'user1',
        text: 'Привет! Как настроение?',
        createdAt: DateTime.now().subtract(Duration(hours: 12)),
        updatedAt: DateTime.now().subtract(Duration(hours: 12)),
        edited: false,
        read: true,
      ),
      Message(
        id: 'msg6',
        owner: 'user3',
        text: 'Всё хорошо, спасибо!',
        createdAt: DateTime.now().subtract(Duration(hours: 10)),
        updatedAt: DateTime.now().subtract(Duration(hours: 10)),
        edited: false,
        read: true,
      ),
    ],
    'chat3': [
      Message(
        id: 'msg7',
        owner: 'user4',
        text: 'Привет! Ты видел новости?',
        createdAt: DateTime.now().subtract(Duration(minutes: 5)),
        updatedAt: DateTime.now().subtract(Duration(minutes: 5)),
        edited: false,
        read: false,
      ),
      Message(
        id: 'msg8',
        owner: 'user1',
        text: 'Да, видел! Очень интересно',
        createdAt: DateTime.now().subtract(Duration(minutes: 3)),
        updatedAt: DateTime.now().subtract(Duration(minutes: 3)),
        edited: false,
        read: true,
      ),
      Message(
        id: 'msg9',
        owner: 'user4',
        text: 'Согласен! 😊',
        createdAt: DateTime.now().subtract(Duration(minutes: 1)),
        updatedAt: DateTime.now().subtract(Duration(minutes: 1)),
        edited: false,
        read: false,
      ),
    ],
    'chat4': [
      Message(
        id: 'msg10',
        owner: 'user5',
        text: 'Привет! Как дела?',
        createdAt: DateTime.now().subtract(Duration(hours: 3)),
        updatedAt: DateTime.now().subtract(Duration(hours: 3)),
        edited: false,
        read: false,
      ),
      Message(
        id: 'msg11',
        owner: 'user1',
        text: 'Всё отлично, спасибо!',
        createdAt: DateTime.now().subtract(Duration(hours: 2, minutes: 30)),
        updatedAt: DateTime.now().subtract(Duration(hours: 2, minutes: 30)),
        edited: false,
        read: true,
      ),
    ],
  };
}

