import 'package:flutter/cupertino.dart';
import 'package:exchats/locator.dart';
import 'package:exchats/models/chat.dart';
import 'package:exchats/models/message.dart';
import 'package:exchats/services/auth_service.dart';
import 'package:exchats/services/chat_service.dart';
import 'package:exchats/services/user_service.dart';
import 'package:exchats/view_models/home/chats/chat_viewmodel.dart';

class GroupViewModel extends ChatViewModel {
  GroupViewModel({
    required Chat chat,
  }) : super(chat: chat) {
    _scrollController.addListener(_onScroll);
  }

  final AuthService _authService = locator<AuthService>();
  final UserService _userService = locator<UserService>();
  final ChatService _chatService = locator<ChatService>();

  String _title = 'Группа';
  int _unreadMessageCounter = 0;
  List<Message> _messages = [];

  final ScrollController _scrollController = ScrollController();
  bool _messageLoading = false;

  String get title => _title;
  int get unreadMessageCounter => _unreadMessageCounter;
  List<Message> get messages => _messages;
  ScrollController get scrollController => _scrollController;

  Future<void> initialize() async {
    final chat = this.chat;
    final currentUserId = _authService.currentUserId ?? '';

    // Получаем название группы из участников
    final otherUsers = chat.users.where((id) => id != currentUserId).toList();
    if (otherUsers.isNotEmpty) {
      final user = await _userService.getUserById(id: otherUsers.first);
      if (user != null) {
        _title = 'Группа: ${user.firstName}';
      } else {
        _title = 'Группа';
      }
    } else {
      _title = 'Группа';
    }

    _messages = await _getMessages();
    _unreadMessageCounter = await _getUnreadMessageCounter();
    listenChatChanges();
  }

  Future<List<Message>> _getMessages() async {
    final messages = await _chatService.getMessages(id: chat.id);
    return messages.reversed.toList();
  }

  Future<int> _getUnreadMessageCounter() async {
    final unreadMessages = await _chatService.getUnreadMessages(id: chat.id);
    return unreadMessages.length;
  }

  void listenChatChanges() {
    _chatService.onChatMessagesChanged(id: chat.id).listen((messages) {
      if (messages.isNotEmpty) {
        _messages = messages.reversed.toList();
        _unreadMessageCounter = messages.where((msg) => !msg.read).length;
        notifyListeners();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_messageLoading) {
        _loadMoreMessages();
      }
    }
  }

  Future<void> _loadMoreMessages() async {
    _messageLoading = true;
    // TODO: Implement load more messages
    _messageLoading = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

