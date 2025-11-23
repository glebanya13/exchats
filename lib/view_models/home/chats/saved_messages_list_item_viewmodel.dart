import 'package:exchats/models/message.dart';
import 'package:exchats/view_models/base_viewmodel.dart';

import 'saved_messages_viewmodel.dart';

class SavedMessagesListItemViewModel extends BaseViewModel {
  late Message _lastMessage;

  Message get lastMessage => _lastMessage;

  update(SavedMessagesViewModel dialogViewModel) {
    if (dialogViewModel.messages.isNotEmpty) {
      _lastMessage = dialogViewModel.messages.first;
      notifyListeners();
    }
  }
}
