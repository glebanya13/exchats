import 'dart:async';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/chat_repository.dart';
import '../../domain/entity/chat_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../datasource/rooms_api_service.dart';
import '../mapper/chat_mapper.dart';
import '../mapper/message_mapper.dart';

@LazySingleton(as: ChatRepository)
final class ChatRepositoryImpl implements ChatRepository {
  final RoomsApiService _roomsApiService;
  final Map<String, StreamController<List<MessageEntity>>> _messageStreams = {};

  ChatRepositoryImpl(this._roomsApiService);

  @override
  Future<List<ChatEntity>> getUserChats(String userId) async {
    final response = await _roomsApiService.getRooms();
    return response.data.map((room) => ChatMapper.toEntity(room)).toList();
  }

  @override
  Future<ChatEntity?> getChatById(String id) async {
    final roomId = int.tryParse(id);
    if (roomId == null) return null;

    try {
      final room = await _roomsApiService.getRoomById(roomId);
      return ChatMapper.toEntity(room);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final roomId = int.tryParse(chatId);
    if (roomId == null) {
      throw ArgumentError('Invalid chatId: $chatId');
    }
    await _roomsApiService.deleteRoom(roomId);
  }

  @override
  Future<void> leaveChat(String chatId) async {
    final roomId = int.tryParse(chatId);
    if (roomId == null) {
      throw ArgumentError('Invalid chatId: $chatId');
    }
    await _roomsApiService.leaveRoom(roomId);
  }

  @override
  Future<ChatEntity> createChat(ChatEntity chat) async {
    if (chat.type == 'private') {
      final otherUserId = chat.participantUserIds
          .where((uid) => uid != chat.owner.id)
          .firstOrNull;
      
      if (otherUserId == null) {
        throw ArgumentError('Для private room нужен otherUserId');
      }

      final otherUserIdInt = int.tryParse(otherUserId);
      if (otherUserIdInt == null) {
        throw ArgumentError('Неверный формат otherUserId: $otherUserId');
      }

      final room = await _roomsApiService.createRoom(
        type: 'private',
        otherUserId: otherUserIdInt,
      );

      return ChatMapper.toEntity(room);
    } else {
      final participantIds = chat.participantUserIds
          .map((uid) => int.tryParse(uid))
          .whereType<int>()
          .toList();

      final room = await _roomsApiService.createRoom(
        type: 'group',
        name: chat.name,
        participantIds: participantIds.isNotEmpty ? participantIds : null,
      );

      return ChatMapper.toEntity(room);
    }
  }

  @override
  Future<List<MessageEntity>> getChatMessages(String chatId) async {
    final roomId = int.tryParse(chatId);
    if (roomId == null) return [];

    final response = await _roomsApiService.getRoomMessages(roomId: roomId);
    return response.data.map((msg) => MessageMapper.toEntity(msg)).toList();
  }

  @override
  Future<MessageEntity> sendMessage(
      String chatId, MessageEntity message) async {
    final roomId = int.tryParse(chatId);
    if (roomId == null) {
      throw ArgumentError('Invalid chatId: $chatId');
    }

    final sentMessage = await _roomsApiService.createMessage(
      roomId: roomId,
      content: message.content,
      type: message.type,
      fileName: message.fileName,
      metadata: message.metadata,
      replyToId: message.replyTo != null
          ? int.tryParse(message.replyTo!['id']?.toString() ?? '')
          : null,
    );

    return MessageMapper.toEntity(sentMessage);
  }

  @override
  Future<MessageEntity> updateMessage(
      String chatId, String messageId, MessageEntity message) async {
    final msgId = int.tryParse(messageId);
    if (msgId == null) {
      throw ArgumentError('Invalid messageId: $messageId');
    }

    final updatedMessage = await _roomsApiService.updateMessage(
      id: msgId,
      content: message.content,
    );

    return MessageMapper.toEntity(updatedMessage);
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    final msgId = int.tryParse(messageId);
    if (msgId == null) {
      throw ArgumentError('Invalid messageId: $messageId');
    }

    await _roomsApiService.deleteMessage(msgId);
  }

  @override
  Future<void> markMessagesAsRead(
      String chatId, List<String> messageIds) async {
    final roomId = int.tryParse(chatId);
    if (roomId == null) {
      throw ArgumentError('Invalid chatId: $chatId');
    }

    await _roomsApiService.markMessagesAsRead(roomId);
  }

  @override
  Stream<List<MessageEntity>> watchChatMessages(String chatId) {
    if (!_messageStreams.containsKey(chatId)) {
      final controller = StreamController<List<MessageEntity>>.broadcast();
      _messageStreams[chatId] = controller;

      getChatMessages(chatId).then((messages) {
        if (!controller.isClosed) {
          controller.add(messages);
        }
      });

      Timer.periodic(const Duration(seconds: 5), (timer) async {
        if (controller.isClosed) {
          timer.cancel();
          return;
        }
        try {
          final messages = await getChatMessages(chatId);
          if (!controller.isClosed) {
            controller.add(messages);
          }
        } catch (e) {
          // ignore
        }
      });
    }
    return _messageStreams[chatId]!.stream;
  }

  void dispose() {
    for (final controller in _messageStreams.values) {
      controller.close();
    }
    _messageStreams.clear();
  }
}
