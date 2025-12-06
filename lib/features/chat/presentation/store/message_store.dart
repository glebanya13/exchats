import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import '../../domain/usecase/chat_usecase.dart';
import '../../domain/entity/message_entity.dart';

part 'message_store.g.dart';

@injectable
class MessageStore = _MessageStore with _$MessageStore;

abstract class _MessageStore with Store {
  final ChatUseCase _chatUseCase;

  _MessageStore(this._chatUseCase);

  @observable
  ObservableList<MessageEntity> messages = ObservableList<MessageEntity>();

  @observable
  bool isLoading = false;

  @observable
  String? error;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  @action
  void watchMessages(String chatId) {
    _messagesSubscription?.cancel();
    _messagesSubscription =
        _chatUseCase.watchChatMessages(chatId).listen((newMessages) {
      runInAction(() {
        final pendingMessages = this.messages
            .where((m) => m.id == '0')
            .toList();
        
        this.messages.clear();
        this.messages.addAll(newMessages);
        
        for (final pending in pendingMessages) {
          final exists = newMessages.any((m) => 
            m.content == pending.content && 
            m.userId == pending.userId &&
            m.insertedAt.difference(pending.insertedAt).inSeconds.abs() < 10
          );
          if (!exists) {
            this.messages.add(pending);
          }
        }
        
        this.messages.sort((a, b) => a.insertedAt.compareTo(b.insertedAt));
      });
    });

    loadMessages(chatId);
  }

  @action
  Future<void> loadMessages(String chatId) async {
    isLoading = true;
    error = null;
    try {
      final loadedMessages = await _chatUseCase.getChatMessages(chatId);
      messages.clear();
      messages.addAll(loadedMessages);
      messages.sort((a, b) => a.insertedAt.compareTo(b.insertedAt));
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> sendMessage(String chatId, MessageEntity message) async {
    try {
      final sentMessage = await _chatUseCase.sendMessage(chatId, message);
      
      final existingIndex = messages.indexWhere((m) => 
        m.id == sentMessage.id || 
        (m.id == '0' && m.content == sentMessage.content && m.userId == sentMessage.userId)
      );
      
      if (existingIndex == -1) {
        messages.add(sentMessage);
      } else {
        messages[existingIndex] = sentMessage;
      }
      
      messages.sort((a, b) => a.insertedAt.compareTo(b.insertedAt));
    } catch (e) {
      error = e.toString();
      rethrow;
    }
  }

  @action
  Future<void> updateMessage(
      String chatId, String messageId, MessageEntity message) async {
    try {
      final updatedMessage =
          await _chatUseCase.updateMessage(chatId, messageId, message);
      final index = messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        messages[index] = updatedMessage;
      }
    } catch (e) {
      error = e.toString();
      rethrow;
    }
  }

  @action
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _chatUseCase.deleteMessage(chatId, messageId);
      messages.removeWhere((m) => m.id == messageId);
    } catch (e) {
      error = e.toString();
      rethrow;
    }
  }

  @action
  Future<void> markMessagesAsRead(
      String chatId, List<String> messageIds) async {
    try {
      await _chatUseCase.markMessagesAsRead(chatId, messageIds);
      for (final messageId in messageIds) {
        final index = messages.indexWhere((m) => m.id == messageId);
        if (index != -1) {
          final message = messages[index];
          messages[index] = MessageEntity(
            id: message.id,
            type: message.type,
            fileName: message.fileName,
            metadata: message.metadata,
            userId: message.userId,
            insertedAt: message.insertedAt,
            content: message.content,
            editedAt: message.editedAt,
            encrypted: message.encrypted,
            fileUrl: message.fileUrl,
            guestName: message.guestName,
            replyTo: message.replyTo,
          );
        }
      }
    } catch (e) {
      error = e.toString();
    }
  }

  void dispose() {
    _messagesSubscription?.cancel();
  }
}
