import 'dart:async';
import '../../domain/repository/chat_repository.dart';
import '../../domain/entity/chat_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../api/api_service.dart';
import '../mapper/chat_mapper.dart';
import '../mapper/message_mapper.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiService _apiService;
  final Map<String, StreamController<List<MessageEntity>>> _messageStreams = {};

  ChatRepositoryImpl(this._apiService);

  @override
  Future<List<ChatEntity>> getUserChats(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      ChatEntity(
        id: 'chat1',
        type: 'dialog',
        messageCounter: 5,
        historyCleared: false,
        users: [userId, 'user2'],
      ),
      ChatEntity(
        id: 'chat2',
        type: 'group',
        messageCounter: 12,
        historyCleared: false,
        users: [userId, 'user2', 'user3', 'user4'],
      ),
    ];
  }

  @override
  Future<ChatEntity?> getChatById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (id == 'chat1') {
      return ChatEntity(
        id: 'chat1',
        type: 'dialog',
        messageCounter: 5,
        historyCleared: false,
        users: ['user1', 'user2'],
      );
    } else if (id == 'chat2') {
      return ChatEntity(
        id: 'chat2',
        type: 'group',
        messageCounter: 12,
        historyCleared: false,
        users: ['user1', 'user2', 'user3', 'user4'],
      );
    }
    
    return null;
  }

  @override
  Future<ChatEntity> createChat(ChatEntity chat) async {
    final chatDto = ChatMapper.toDto(chat);
    final createdDto = await _apiService.createChat(chatDto);
    return ChatMapper.toEntity(createdDto);
  }

  @override
  Future<List<MessageEntity>> getChatMessages(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final now = DateTime.now();
    
    if (chatId == 'chat1') {
      return [
        MessageEntity(
          id: 'msg1',
          owner: 'user2',
          text: 'Привет! Как дела?',
          createdAt: now.subtract(const Duration(days: 2, hours: 3)),
          updatedAt: now.subtract(const Duration(days: 2, hours: 3)),
          edited: false,
          read: true,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg2',
          owner: 'user1',
          text: 'Привет! Всё отлично, спасибо! А у тебя как?',
          createdAt: now.subtract(const Duration(days: 2, hours: 2, minutes: 50)),
          updatedAt: now.subtract(const Duration(days: 2, hours: 2, minutes: 50)),
          edited: false,
          read: true,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg3',
          owner: 'user2',
          text: 'Тоже всё хорошо! Спасибо, что спросил 😊',
          createdAt: now.subtract(const Duration(days: 2, hours: 2, minutes: 40)),
          updatedAt: now.subtract(const Duration(days: 2, hours: 2, minutes: 40)),
          edited: false,
          read: true,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg4',
          owner: 'user1',
          text: 'Отлично! Кстати, ты не забыл про встречу завтра?',
          createdAt: now.subtract(const Duration(days: 1, hours: 5)),
          updatedAt: now.subtract(const Duration(days: 1, hours: 5)),
          edited: false,
          read: true,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg5',
          owner: 'user2',
          text: 'Конечно помню! В 10:00, правильно?',
          createdAt: now.subtract(const Duration(days: 1, hours: 4, minutes: 50)),
          updatedAt: now.subtract(const Duration(days: 1, hours: 4, minutes: 50)),
          edited: false,
          read: true,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg6',
          owner: 'user1',
          text: 'Да, именно так! Увидимся там',
          createdAt: now.subtract(const Duration(days: 1, hours: 4, minutes: 45)),
          updatedAt: now.subtract(const Duration(days: 1, hours: 4, minutes: 45)),
          edited: false,
          read: true,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg7',
          owner: 'user2',
          text: 'Отлично! До встречи! 👋',
          createdAt: now.subtract(const Duration(days: 1, hours: 4, minutes: 40)),
          updatedAt: now.subtract(const Duration(days: 1, hours: 4, minutes: 40)),
          edited: false,
          read: true,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg8',
          owner: 'user1',
          text: 'Кстати, ты видел новую версию приложения?',
          createdAt: now.subtract(const Duration(hours: 3)),
          updatedAt: now.subtract(const Duration(hours: 3)),
          edited: false,
          read: false,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg9',
          owner: 'user2',
          text: 'Да, видел! Очень круто получилось!',
          createdAt: now.subtract(const Duration(hours: 2, minutes: 50)),
          updatedAt: now.subtract(const Duration(hours: 2, minutes: 50)),
          edited: false,
          read: false,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg10',
          owner: 'user1',
          text: 'Согласен! Особенно понравился новый дизайн',
          createdAt: now.subtract(const Duration(hours: 2, minutes: 40)),
          updatedAt: now.subtract(const Duration(hours: 2, minutes: 40)),
          edited: false,
          read: false,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg11',
          owner: 'user2',
          text: 'Ага, и интерфейс стал намного удобнее',
          createdAt: now.subtract(const Duration(hours: 2, minutes: 30)),
          updatedAt: now.subtract(const Duration(hours: 2, minutes: 30)),
          edited: false,
          read: false,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg12',
          owner: 'user1',
          text: 'Точно! Кстати, можешь прислать файл, который мы обсуждали?',
          createdAt: now.subtract(const Duration(hours: 1)),
          updatedAt: now.subtract(const Duration(hours: 1)),
          edited: false,
          read: false,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg13',
          owner: 'user2',
          text: 'Конечно! Сейчас отправлю',
          createdAt: now.subtract(const Duration(minutes: 50)),
          updatedAt: now.subtract(const Duration(minutes: 50)),
          edited: false,
          read: false,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg14',
          owner: 'user2',
          text: 'Отправил! Проверь, пожалуйста',
          createdAt: now.subtract(const Duration(minutes: 45)),
          updatedAt: now.subtract(const Duration(minutes: 45)),
          edited: false,
          read: false,
          type: 'text',
        ),
        MessageEntity(
          id: 'msg15',
          owner: 'user1',
          text: 'Спасибо! Получил, всё отлично 👍',
          createdAt: now.subtract(const Duration(minutes: 30)),
          updatedAt: now.subtract(const Duration(minutes: 30)),
          edited: false,
          read: false,
          type: 'text',
        ),
      ];
    }
    
    return [];
  }

  @override
  Future<MessageEntity> sendMessage(String chatId, MessageEntity message) async {
    final messageDto = MessageMapper.toDto(message);
    final sentDto = await _apiService.sendMessage(chatId, messageDto);
    return MessageMapper.toEntity(sentDto);
  }

  @override
  Future<MessageEntity> updateMessage(String chatId, String messageId, MessageEntity message) async {
    final messageDto = MessageMapper.toDto(message);
    final updatedDto = await _apiService.updateMessage(chatId, messageId, messageDto);
    return MessageMapper.toEntity(updatedDto);
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _apiService.deleteMessage(chatId, messageId);
  }

  @override
  Future<void> markMessagesAsRead(String chatId, List<String> messageIds) async {
    await _apiService.markMessagesAsRead(chatId, messageIds);
  }

  @override
  Stream<List<MessageEntity>> watchChatMessages(String chatId) {
    if (!_messageStreams.containsKey(chatId)) {
      final controller = StreamController<List<MessageEntity>>.broadcast();
      _messageStreams[chatId] = controller;
      
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (controller.isClosed) {
          timer.cancel();
          return;
        }
        final messages = await getChatMessages(chatId);
        controller.add(messages);
      });
      
      getChatMessages(chatId).then((messages) {
        if (!controller.isClosed) {
          controller.add(messages);
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

