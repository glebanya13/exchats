import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../domain/usecase/chat_usecase.dart';
import '../../domain/entity/message_entity.dart';

part 'message_store.g.dart';

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
        _chatUseCase.watchChatMessages(chatId).listen((messages) {
      this.messages.clear();
      this.messages.addAll(messages);
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
      messages.add(sentMessage);
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
            owner: message.owner,
            text: message.text,
            createdAt: message.createdAt,
            updatedAt: message.updatedAt,
            edited: message.edited,
            read: true,
            replyTo: message.replyTo,
            type: message.type,
            callDuration: message.callDuration,
            participants: message.participants,
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
