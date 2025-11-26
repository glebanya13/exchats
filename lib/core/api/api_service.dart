import '../../features/user/data/dto/user_dto.dart';
import '../../features/chat/data/dto/chat_dto.dart';
import '../../features/chat/data/dto/message_dto.dart';

abstract class ApiService {
  Future<Map<String, dynamic>> sendVerificationCode(String phoneNumber);
  Future<Map<String, dynamic>> verifyCode({
    required String phoneNumber,
    required String code,
  });

  Future<UserDto> getUserById(String id);
  Future<UserDto> createUser(UserDto user);
  Future<UserDto> updateUser(String id, UserDto user);
  Future<void> updateOnlineStatus(String id, bool online);
  Future<List<ChatDto>> getUserChats(String userId);

  Future<ChatDto> getChatById(String id);
  Future<ChatDto> createChat(ChatDto chat);

  Future<List<MessageDto>> getChatMessages(String chatId);
  Future<MessageDto> sendMessage(String chatId, MessageDto message);
  Future<MessageDto> updateMessage(String chatId, String messageId, MessageDto message);
  Future<void> deleteMessage(String chatId, String messageId);
  Future<void> markMessagesAsRead(String chatId, List<String> messageIds);
}
