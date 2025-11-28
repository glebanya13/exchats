import 'dart:math';
import 'package:injectable/injectable.dart';

import 'api_service.dart';
import 'mock_data.dart';
import '../../features/user/data/dto/user_dto.dart';
import '../../features/chat/data/dto/chat_dto.dart';
import '../../features/chat/data/dto/message_dto.dart';

@Singleton(as: ApiService)
class MockApiService implements ApiService {
  final Random _random = Random();

  MockApiService();

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

    for (final entry in MockData.users.entries) {
      if (entry.value.phone == phoneNumber) {
        return {
          'access_token': 'mock_access_token_${_random.nextInt(10000)}',
          'refresh_token': 'mock_refresh_token_${_random.nextInt(10000)}',
          'user_id': entry.key,
        };
      }
    }

    final userId = 'user_${_random.nextInt(10000)}';
    MockData.users[userId] = UserDto(
      id: userId,
      name: 'User',
      username: phoneNumber.replaceAll('+', ''),
      phone: phoneNumber,
      email: '$phoneNumber@example.com',
      avatarUrl: '',
      insertedAt: DateTime.now(),
      lastSeenAt: DateTime.now(),
      chats: [],
    );

    return {
      'access_token': 'mock_access_token_${_random.nextInt(10000)}',
      'refresh_token': 'mock_refresh_token_${_random.nextInt(10000)}',
      'user_id': userId,
    };
  }

  @override
  Future<UserDto> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = MockData.users[id];
    if (user != null) {
      return user;
    }

    return UserDto(
      id: id,
      name: 'User',
      username: 'user_$id',
      phone: '+0000000000',
      email: 'user_$id@example.com',
      avatarUrl: '',
      insertedAt: DateTime.now(),
      lastSeenAt: DateTime.now(),
      chats: [],
    );
  }

  @override
  Future<UserDto> createUser(UserDto user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockData.users[user.id] = user;
    return user;
  }

  @override
  Future<UserDto> updateUser(String id, UserDto user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final updatedUser = UserDto(
      id: id,
      name: user.name,
      username: user.username,
      phone: user.phone,
      email: user.email,
      avatarUrl: user.avatarUrl,
      insertedAt: user.insertedAt,
      lastSeenAt: user.lastSeenAt,
      chats: user.chats,
    );
    MockData.users[id] = updatedUser;
    return updatedUser;
  }

  @override
  Future<List<ChatDto>> getUserChats(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = MockData.users[userId];
    if (user == null) return [];

    return user.chats
        .map((chatId) => MockData.chats[chatId])
        .whereType<ChatDto>()
        .toList();
  }

  @override
  Future<ChatDto> getChatById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final chat = MockData.chats[id];
    if (chat != null) {
      return chat;
    }

    return ChatDto(
      id: id,
      type: 'dialog',
      messageCounter: 0,
      historyCleared: false,
      users: [],
    );
  }

  @override
  Future<ChatDto> createChat(ChatDto chat) async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockData.chats[chat.id] = chat;
    return chat;
  }

  @override
  Future<List<MessageDto>> getChatMessages(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.messages[chatId] ?? [];
  }

  @override
  Future<MessageDto> sendMessage(String chatId, MessageDto message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final messages = MockData.messages[chatId] ?? [];
    messages.add(message);
    MockData.messages[chatId] = messages;
    return message;
  }

  @override
  Future<MessageDto> updateMessage(
      String chatId, String messageId, MessageDto message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final messages = MockData.messages[chatId] ?? [];
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = message;
      MockData.messages[chatId] = messages;
    }
    return message;
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final messages = MockData.messages[chatId] ?? [];
    messages.removeWhere((m) => m.id == messageId);
    MockData.messages[chatId] = messages;
  }

  @override
  Future<void> markMessagesAsRead(
      String chatId, List<String> messageIds) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final messages = MockData.messages[chatId] ?? [];
    for (final message in messages) {
      if (messageIds.contains(message.id)) {
        final index = messages.indexOf(message);
        messages[index] = MessageDto(
          id: message.id,
          owner: message.owner,
          text: message.text,
          createdAt: message.createdAt,
          updatedAt: message.updatedAt,
          edited: message.edited,
          read: true,
          type: message.type,
          replyTo: message.replyTo,
          participants: message.participants,
          callDuration: message.callDuration,
        );
      }
    }
    MockData.messages[chatId] = messages;
  }
}
