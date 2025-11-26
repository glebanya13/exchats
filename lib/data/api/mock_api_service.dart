import 'dart:math';
import 'api_provider.dart';
import 'api_service.dart';
import '../dto/user_dto.dart';
import '../dto/chat_dto.dart';
import '../dto/message_dto.dart';
import '../mock/mock_data.dart';
import '../../domain/entity/user_entity.dart';

class MockApiService implements ApiService {
  final ApiProvider _apiProvider;
  final Random _random = Random();

  MockApiService(this._apiProvider);

  @override
  Future<Map<String, dynamic>> sendVerificationCode(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'verification_id': 'mock_verification_id_${_random.nextInt(10000)}',
    };
  }

  @override
  Future<Map<String, dynamic>> verifyCode({
    required String phoneNumber,
    required String code,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    

    UserEntity? user;
    for (final entry in MockData.users.entries) {
      if (entry.value.phoneNumber == phoneNumber) {
        user = UserEntity(
          id: entry.key,
          username: entry.value.username,
          firstName: entry.value.firstName,
          lastName: entry.value.lastName,
          phoneNumber: entry.value.phoneNumber,
          online: entry.value.online,
          chats: entry.value.chats,
        );
        break;
      }
    }


    if (user == null) {
      final userId = 'user_${_random.nextInt(10000)}';
      final username = 'User${_random.nextInt(10000)}';
      user = UserEntity(
        id: userId,
        username: username,
        firstName: username,
        lastName: '',
        phoneNumber: phoneNumber,
        online: true,
        chats: [],
      );
      

      MockData.users[userId] = UserDto(
        id: userId,
        username: username,
        firstName: username,
        lastName: '',
        phoneNumber: phoneNumber,
        online: true,
        chats: [],
      );
    }

    return {
      'access_token': 'mock_access_token_${_random.nextInt(10000)}',
      'refresh_token': 'mock_refresh_token_${_random.nextInt(10000)}',
      'user_id': user.id,
    };
  }

  @override
  Future<UserDto> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = MockData.users[id];
    if (user == null) {
      throw Exception('User not found');
    }
    return user;
  }

  @override
  Future<UserDto> createUser(UserDto user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    MockData.users[user.id] = user;
    return user;
  }

  @override
  Future<UserDto> updateUser(String id, UserDto user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    MockData.users[id] = user;
    return user;
  }

  @override
  Future<void> updateOnlineStatus(String id, bool online) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = MockData.users[id];
    if (user != null) {
      MockData.users[id] = UserDto(
        id: user.id,
        username: user.username,
        firstName: user.firstName,
        lastName: user.lastName,
        phoneNumber: user.phoneNumber,
        online: online,
        chats: user.chats,
      );
    }
  }

  @override
  Future<List<ChatDto>> getUserChats(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('MockApiService: getUserChats called with userId: $userId');
    final user = MockData.users[userId];
    if (user == null) {
      print('MockApiService: User not found for userId: $userId');
      return [];
    }
    
    print('MockApiService: User found, chats: ${user.chats}');
    final chats = user.chats
        .map((chatId) => MockData.chats[chatId])
        .whereType<ChatDto>()
        .toList();
    print('MockApiService: Returning ${chats.length} chats');
    return chats;
  }

  @override
  Future<ChatDto> getChatById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final chat = MockData.chats[id];
    if (chat == null) {
      throw Exception('Chat not found');
    }
    return ChatDto(
      id: chat.id,
      type: chat.type,
      messageCounter: chat.messageCounter,
      historyCleared: chat.historyCleared,
      users: chat.users,
    );
  }

  @override
  Future<ChatDto> createChat(ChatDto chat) async {
    await Future.delayed(const Duration(milliseconds: 500));
    MockData.chats[chat.id] = chat;
    return chat;
  }

  @override
  Future<List<MessageDto>> getChatMessages(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.messages[chatId] ?? [];
  }

  @override
  Future<MessageDto> sendMessage(String chatId, MessageDto message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final messages = MockData.messages[chatId] ?? [];
    final newMessage = MessageDto(
      id: message.id.isEmpty ? 'msg_${_random.nextInt(100000)}' : message.id,
      owner: message.owner,
      text: message.text,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      edited: message.edited,
      read: message.read,
      replyTo: message.replyTo,
      type: message.type,
      callDuration: message.callDuration,
      participants: message.participants,
    );
    messages.add(newMessage);
    MockData.messages[chatId] = messages;
    
    return newMessage;
  }

  @override
  Future<MessageDto> updateMessage(String chatId, String messageId, MessageDto message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final messages = MockData.messages[chatId] ?? [];
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = MessageDto(
        id: messageId,
        owner: message.owner,
        text: message.text,
        createdAt: message.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        edited: true,
        read: message.read,
        replyTo: message.replyTo,
        type: message.type,
        callDuration: message.callDuration,
        participants: message.participants,
      );
    }
    return message;
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final messages = MockData.messages[chatId] ?? [];
    messages.removeWhere((m) => m.id == messageId);
  }

  @override
  Future<void> markMessagesAsRead(String chatId, List<String> messageIds) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final messages = MockData.messages[chatId] ?? [];
    for (final messageId in messageIds) {
      final index = messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        final msg = messages[index];
        messages[index] = MessageDto(
          id: msg.id,
          owner: msg.owner,
          text: msg.text,
          createdAt: msg.createdAt,
          updatedAt: msg.updatedAt,
          edited: msg.edited,
          read: true,
          replyTo: msg.replyTo,
          type: msg.type,
          callDuration: msg.callDuration,
          participants: msg.participants,
        );
      }
    }
  }
}

