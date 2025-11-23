import 'package:exchats/models/chat.dart';
import 'package:exchats/view_models/base_viewmodel.dart';

abstract class ChatViewModel extends BaseViewModel {
  ChatViewModel({
    required Chat chat,
  }) : _chat = chat;

  Chat _chat;

  Chat get chat => _chat;
  String get id => _chat.id;
}
