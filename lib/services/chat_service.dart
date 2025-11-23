import 'dart:async';
import 'package:exchats/models/chat.dart';
import 'package:exchats/models/message.dart';
import 'package:exchats/services/mock_data.dart';

class ChatService {
  static const String _kCollectionName = 'chats';

  Stream<List<Message>> onChatMessagesChanged({required String id}) {
    final controller = StreamController<List<Message>>.broadcast();
    
    // Эмулируем поток данных
    Timer.periodic(Duration(seconds: 2), (timer) {
      final messages = _getMessages(id);
      controller.add(messages);
    });
    
    // Отправляем начальное значение
    Future.microtask(() {
      final messages = _getMessages(id);
      controller.add(messages);
    });
    
    return controller.stream;
  }

  Future<List<Message>> getMessages({required String id}) async {
    return _getMessages(id);
  }

  List<Message> _getMessages(String chatId) {
    return MockData.messages[chatId] ?? [];
  }

  Future<List<Message>> getUnreadMessages({required String id}) async {
    final messages = _getMessages(id);
    return messages.where((msg) => !msg.read).toList();
  }

  Future<Chat?> getChatById({required String id}) async {
    return _getChatById(id);
  }

  Chat? _getChatById(String id) {
    return MockData.chats[id];
  }
}
