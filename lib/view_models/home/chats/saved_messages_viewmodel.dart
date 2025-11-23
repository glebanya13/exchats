import 'package:exchats/locator.dart';
import 'package:exchats/models/chat.dart';
import 'package:exchats/models/message.dart';
import 'package:exchats/services/chat_service.dart';
import 'package:exchats/view_models/home/chats/chat_viewmodel.dart';

class SavedMessagesViewModel extends ChatViewModel {
  SavedMessagesViewModel({
    required Chat chat,
  }) : super(chat: chat);

  final ChatService _chatService = locator<ChatService>();

  late String _title;
  late List<Message> _messages;

  String get title => _title;
  List<Message> get messages => _messages;

  Future<void> initialize() async {
    _title = 'Saved Messages';
    _messages = await _getMessages();
    listenChatChanges();
  }

  Future<List<Message>> _getMessages() async {
    final messages = await _chatService.getMessages(id: chat.id);
    return messages.reversed.toList();
  }

  void listenChatChanges() {
    _chatService.onChatMessagesChanged(id: chat.id).listen((messages) {
      if (messages.isNotEmpty) {
        _messages = messages.reversed.toList();
        notifyListeners();
      }
    });
  }
}
