import 'package:exchats/models/message.dart';
import 'package:exchats/view_models/base_viewmodel.dart';

import 'dialog_viewmodel.dart';
import 'group_viewmodel.dart';

class DialogListItemViewModel extends BaseViewModel {
  Message? _lastMessage;

  Message get lastMessage => _lastMessage ?? Message(
    id: '',
    owner: '',
    text: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    edited: false,
    read: false,
  );

  update(DialogViewModel dialogViewModel) {
    if (dialogViewModel.messages.isNotEmpty) {
      _lastMessage = dialogViewModel.messages.first;
      notifyListeners();
    }
  }

  updateGroupViewModel(GroupViewModel groupViewModel) {
    if (groupViewModel.messages.isNotEmpty) {
      _lastMessage = groupViewModel.messages.first;
      notifyListeners();
    }
  }
}
