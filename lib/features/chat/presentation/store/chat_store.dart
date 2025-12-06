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
      final loadedChats = await _chatUseCase.getUserChats(userId);
      chats.clear();
      chats.addAll(loadedChats);
      
      lastMessages.clear();
      for (final chat in loadedChats) {
        lastMessages[chat.id] = chat.lastMessage;
      }
      
      chatsLoaded = true;
    } catch (e) {
      error = e.toString();
      chatsLoaded = false;
    } finally {
      isLoading = false;
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

  @action
  Future<void> deleteChat(String chatId) async {
    isLoading = true;
    try {
      await _chatUseCase.deleteChat(chatId);
      chats.removeWhere((chat) => chat.id == chatId);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> leaveChat(String chatId) async {
    isLoading = true;
    try {
      await _chatUseCase.leaveChat(chatId);
      chats.removeWhere((chat) => chat.id == chatId);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
