import '../entity/chat_entity.dart';
import '../entity/message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatEntity>> getUserChats(String userId);
  Future<ChatEntity?> getChatById(String id);
  Future<ChatEntity> createChat(ChatEntity chat);
  Future<void> deleteChat(String chatId);
  Future<void> leaveChat(String chatId);
  Future<List<MessageEntity>> getChatMessages(String chatId);
  Future<MessageEntity> sendMessage(String chatId, MessageEntity message);
  Future<MessageEntity> updateMessage(
      String chatId, String messageId, MessageEntity message);
  Future<void> deleteMessage(String chatId, String messageId);
  Future<void> markMessagesAsRead(String chatId, List<String> messageIds);
  Stream<List<MessageEntity>> watchChatMessages(String chatId);
}
