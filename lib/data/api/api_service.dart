import 'api_provider.dart';
import '../dto/user_dto.dart';
import '../dto/chat_dto.dart';
import '../dto/message_dto.dart';

class ApiService {
  final ApiProvider _apiProvider;

  ApiService(this._apiProvider);


  Future<Map<String, dynamic>> sendVerificationCode(String phoneNumber) async {
    final response = await _apiProvider.post(
      '/auth/send-code',
      data: {'phone_number': phoneNumber},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyCode({
    required String phoneNumber,
    required String code,
  }) async {
    final response = await _apiProvider.post(
      '/auth/verify-code',
      data: {
        'phone_number': phoneNumber,
        'code': code,
      },
    );
    return response.data as Map<String, dynamic>;
  }


  Future<UserDto> getUserById(String id) async {
    final response = await _apiProvider.get('/users/$id');
    return UserDto.fromJson(response.data as Map<String, dynamic>, id: id);
  }

  Future<UserDto> createUser(UserDto user) async {
    final response = await _apiProvider.post(
      '/users',
      data: user.toJson(),
    );
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserDto> updateUser(String id, UserDto user) async {
    final response = await _apiProvider.put(
      '/users/$id',
      data: user.toJson(),
    );
    return UserDto.fromJson(response.data as Map<String, dynamic>, id: id);
  }

  Future<void> updateOnlineStatus(String id, bool online) async {
    await _apiProvider.put(
      '/users/$id/online',
      data: {'online': online},
    );
  }


  Future<List<ChatDto>> getUserChats(String userId) async {
    final response = await _apiProvider.get('/users/$userId/chats');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => ChatDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<ChatDto> getChatById(String id) async {
    final response = await _apiProvider.get('/chats/$id');
    return ChatDto.fromJson(response.data as Map<String, dynamic>, id: id);
  }

  Future<ChatDto> createChat(ChatDto chat) async {
    final response = await _apiProvider.post(
      '/chats',
      data: chat.toJson(),
    );
    return ChatDto.fromJson(response.data as Map<String, dynamic>);
  }


  Future<List<MessageDto>> getChatMessages(String chatId) async {
    final response = await _apiProvider.get('/chats/$chatId/messages');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => MessageDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<MessageDto> sendMessage(String chatId, MessageDto message) async {
    final response = await _apiProvider.post(
      '/chats/$chatId/messages',
      data: message.toJson(),
    );
    return MessageDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<MessageDto> updateMessage(String chatId, String messageId, MessageDto message) async {
    final response = await _apiProvider.put(
      '/chats/$chatId/messages/$messageId',
      data: message.toJson(),
    );
    return MessageDto.fromJson(response.data as Map<String, dynamic>, id: messageId);
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await _apiProvider.delete('/chats/$chatId/messages/$messageId');
  }

  Future<void> markMessagesAsRead(String chatId, List<String> messageIds) async {
    await _apiProvider.post(
      '/chats/$chatId/messages/read',
      data: {'message_ids': messageIds},
    );
  }
}

