import 'package:exchats/locator.dart';
import 'package:exchats/models/chat.dart';
import 'package:exchats/models/message.dart';
import 'package:exchats/services/chat_service.dart';
import 'package:exchats/services/user_service.dart';
import 'package:exchats/view_models/base_viewmodel.dart';
import 'package:exchats/view_models/home/chats/saved_messages_viewmodel.dart';
import 'package:exchats/view_models/home/chats/chat_viewmodel.dart';
import 'package:exchats/view_models/home/chats/dialog_viewmodel.dart';
import 'package:exchats/view_models/home/chats/group_viewmodel.dart';

class ChatsViewModel extends BaseViewModel {
  final UserService _userService = locator<UserService>();
  final ChatService _chatService = locator<ChatService>();

  List<ChatViewModel> _chats = [];
  bool _chatsLoaded = false;

  List<ChatViewModel> get chats => _chats;
  bool get chatsLoaded => _chatsLoaded;

  set chatsLoaded(bool loaded) {
    _chatsLoaded = loaded;
    notifyListeners();
  }

  void loadChats() async {
    final chatIds = await _userService.getChats();

    for (final chatId in chatIds) {
      final chat = await _chatService.getChatById(id: chatId);

      if (chat != null) {
        switch (chat.type) {
          case ChatType.SavedMessages:
            final model = SavedMessagesViewModel(chat: chat);
            await model.initialize();
            _chats.add(model);
            break;
          case ChatType.Dialog:
            final model = DialogViewModel(chat: chat);
            await model.initialize();
            _chats.add(model);
            break;
          case ChatType.Group:
            final model = GroupViewModel(chat: chat);
            await model.initialize();
            _chats.add(model);
            break;
        }
      }
    }

    listenChatsChanges();
    chatsLoaded = true;
  }

  void listenChatsChanges() {
    _chats.forEach((chat) {
      _chatService.onChatMessagesChanged(id: chat.id).listen((_) {
        _sortChatsByLastMessageDate();
      });
    });
  }

  void _sortChatsByLastMessageDate() {
    _chats.sort((a, b) {
      final lastMessageA = _getLastMessage(a);
      final lastMessageB = _getLastMessage(b);
      if (lastMessageA != null && lastMessageB != null) {
        return lastMessageB.createdAt.compareTo(lastMessageA.createdAt);
      } else {
        return 0;
      }
    });
    notifyListeners();
  }

  Message? _getLastMessage(ChatViewModel chatViewModel) {
    if (chatViewModel is SavedMessagesViewModel) {
      return chatViewModel.messages.isNotEmpty ? chatViewModel.messages.first : null;
    } else if (chatViewModel is DialogViewModel) {
      return chatViewModel.messages.isNotEmpty ? chatViewModel.messages.first : null;
    }
    return null;
  }
}
