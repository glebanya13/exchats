import 'dart:async';
import 'package:injectable/injectable.dart';

import '../repository/chat_repository.dart';
import '../entity/chat_entity.dart';
import '../entity/message_entity.dart';

@lazySingleton
final class ChatUseCase {
  final ChatRepository _chatRepository;

  ChatUseCase(this._chatRepository);

  Future<List<ChatEntity>> getUserChats(String userId) {
    return _chatRepository.getUserChats(userId);
  }

  Future<ChatEntity?> getChatById(String id) {
    return _chatRepository.getChatById(id);
  }

  Future<ChatEntity> createChat(ChatEntity chat) {
    return _chatRepository.createChat(chat);
  }

  Future<void> deleteChat(String chatId) {
    return _chatRepository.deleteChat(chatId);
  }

  Future<void> leaveChat(String chatId) {
    return _chatRepository.leaveChat(chatId);
  }

  Future<List<MessageEntity>> getChatMessages(String chatId) {
    return _chatRepository.getChatMessages(chatId);
  }

  Future<MessageEntity> sendMessage(String chatId, MessageEntity message) {
    return _chatRepository.sendMessage(chatId, message);
  }

  Future<MessageEntity> updateMessage(
      String chatId, String messageId, MessageEntity message) {
    return _chatRepository.updateMessage(chatId, messageId, message);
  }

  Future<void> deleteMessage(String chatId, String messageId) {
    return _chatRepository.deleteMessage(chatId, messageId);
  }

  Future<void> markMessagesAsRead(String chatId, List<String> messageIds) {
    return _chatRepository.markMessagesAsRead(chatId, messageIds);
  }

  Stream<List<MessageEntity>> watchChatMessages(String chatId) {
    return _chatRepository.watchChatMessages(chatId);
  }
}
