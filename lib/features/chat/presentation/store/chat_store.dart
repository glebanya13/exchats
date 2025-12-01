import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import '../../domain/usecase/chat_usecase.dart';
import '../../domain/entity/chat_entity.dart';
import '../../domain/entity/message_entity.dart';

part 'chat_store.g.dart';

@lazySingleton
final class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final ChatUseCase _chatUseCase;

  _ChatStore(this._chatUseCase);

  @observable
  ObservableList<ChatEntity> chats = ObservableList<ChatEntity>();

  @observable
  ObservableMap<String, MessageEntity?> lastMessages =
      ObservableMap<String, MessageEntity?>();

  @observable
  bool chatsLoaded = false;

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  Future<void> loadChats(String userId) async {
    isLoading = true;
    error = null;
    chatsLoaded = false;
    try {
      if (kDebugMode) {
        debugPrint('ChatStore: Loading chats for userId: $userId');
      }
      final loadedChats = await _chatUseCase.getUserChats(userId);
      if (kDebugMode) {
        debugPrint('ChatStore: Loaded ${loadedChats.length} chats');
      }
      chats.clear();
      chats.addAll(loadedChats);
      if (kDebugMode) {
        debugPrint('ChatStore: Added ${chats.length} chats to observable list');
      }
      chatsLoaded = true;

      for (final chat in loadedChats) {
        _loadLastMessage(chat.id);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('ChatStore: Error loading chats: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      error = e.toString();
      chatsLoaded = false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _loadLastMessage(String chatId) async {
    try {
      final messages = await _chatUseCase.getChatMessages(chatId);
      if (messages.isNotEmpty) {
        final sortedMessages = List<MessageEntity>.from(messages)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        lastMessages[chatId] = sortedMessages.first;
      } else {
        lastMessages[chatId] = null;
      }
    } catch (e) {
      lastMessages[chatId] = null;
    }
  }

  @action
  Future<ChatEntity?> getChatById(String id) async {
    try {
      return await _chatUseCase.getChatById(id);
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  @action
  Future<ChatEntity> createChat(ChatEntity chat) async {
    isLoading = true;
    try {
      final createdChat = await _chatUseCase.createChat(chat);
      chats.add(createdChat);
      return createdChat;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
