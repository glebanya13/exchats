import 'package:flutter/cupertino.dart';
import 'package:exchats/locator.dart';
import 'package:exchats/models/chat.dart';
import 'package:exchats/models/message.dart';
import 'package:exchats/services/auth_service.dart';
import 'package:exchats/services/chat_service.dart';
import 'package:exchats/services/user_service.dart';
import 'package:exchats/view_models/home/chats/chat_viewmodel.dart';

class DialogViewModel extends ChatViewModel {
  DialogViewModel({
    required Chat chat,
  }) : super(chat: chat) {
    _scrollController.addListener(_onScroll);
  }

  final AuthService _authService = locator<AuthService>();
  final UserService _userService = locator<UserService>();
  final ChatService _chatService = locator<ChatService>();

  String _title = '';
  String _dialogUserId = '';
  String _dialogUserOnlineStatus = 'был(а) недавно';
  bool _dialogUserOnline = false;
  int _unreadMessageCounter = 0;
  List<Message> _messages = [];

  final ScrollController _scrollController = ScrollController();
  bool _messageLoading = false;

  String get title => _title;
  String get dialogUserId => _dialogUserId;
  bool get dialogUserOnline => _dialogUserOnline;
  int get unreadMessageCounter => _unreadMessageCounter;
  String get dialogUserOnlineStatus => _dialogUserOnlineStatus;
  List<Message> get messages => _messages;
  ScrollController get scrollController => _scrollController;

  Future<void> initialize() async {
    final chat = this.chat;
    final currentUserId = _authService.currentUserId ?? '';
    final dialogUserId = chat.users.firstWhere(
      (userId) => userId != currentUserId,
      orElse: () => chat.users.isNotEmpty ? chat.users[0] : '',
    );
    
    final dialogUser = await _userService.getUserById(id: dialogUserId);
    
    if (dialogUser != null) {
      _title = '${dialogUser.firstName} ${dialogUser.lastName}'.trim();
      _messages = await _getMessages();
      _dialogUserId = dialogUserId;
      _changeOnlineStatus(dialogUser.online);
      _unreadMessageCounter = await _getUnreadMessageCounter();

      listenUserChanges();
      listenChatChanges();
    }
  }

  Future<List<Message>> _getMessages() async {
    final messages = await _chatService.getMessages(id: chat.id);
    return messages.reversed.toList(); // Сортируем по дате (новые внизу)
  }

  Future<int> _getUnreadMessageCounter() async {
    final unreadMessages = await _chatService.getUnreadMessages(id: chat.id);
    return unreadMessages
        .where((message) => message.owner == _dialogUserId)
        .length;
  }

  void _changeOnlineStatus(bool online) {
    _dialogUserOnline = online;
    if (online) {
      _dialogUserOnlineStatus = 'В сети';
    } else {
      _dialogUserOnlineStatus = 'был(а) недавно';
    }
  }

  void listenUserChanges() {
    _userService.onUserChanged(id: _dialogUserId).listen((user) {
      if (user != null) {
        _title = '${user.firstName.trim()} ${user.lastName.trim()}';
        _changeOnlineStatus(user.online);
        notifyListeners();
      }
    });
  }

  void listenChatChanges() {
    _chatService.onChatMessagesChanged(id: chat.id).listen((messages) {
      if (messages.isNotEmpty) {
        _messages = messages.reversed.toList();
        _unreadMessageCounter = messages
            .where((message) => !message.read && message.owner == _dialogUserId)
            .length;
        notifyListeners();
      }
    });
  }

  void _onScroll() {
    // Load more messages when scrolling
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
