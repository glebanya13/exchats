import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:exchats/ui/shared_widgets/appbar_icon_button.dart';
import 'package:exchats/view_models/home/chats/chats_viewmodel.dart';
import 'package:exchats/view_models/home/chats/dialog_list_item_viewmodel.dart';
import 'package:exchats/view_models/home/chats/saved_messages_list_item_viewmodel.dart';
import 'package:exchats/view_models/home/chats/dialog_viewmodel.dart';
import 'package:exchats/view_models/home/chats/saved_messages_viewmodel.dart';
import 'package:exchats/view_models/home/chats/chat_viewmodel.dart';
import 'widgets/dialog_list_item.dart';
import 'widgets/saved_messages_list_item.dart';
import 'widgets/swipeable_chat_item.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: AppBarIconButton(
          icon: Icons.arrow_back,
          iconColor: Colors.black87,
          onTap: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Архив',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Consumer<ChatsViewModel>(
        builder: (context, model, child) {
          // Фильтруем только архивные чаты (можно добавить флаг isArchived в модель)
          final archivedChats = model.chats; // Пока показываем все чаты
          
          if (archivedChats.isEmpty) {
            return Center(
              child: Text(
                'Архив пуст',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: archivedChats.length,
            itemBuilder: (context, index) {
              final chatViewModel = archivedChats[index];

              if (chatViewModel is SavedMessagesViewModel) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider<SavedMessagesViewModel>.value(
                      value: chatViewModel,
                    ),
                    ChangeNotifierProxyProvider<SavedMessagesViewModel,
                        SavedMessagesListItemViewModel>(
                      create: (_) => SavedMessagesListItemViewModel(),
                      update: (_, viewModel, listItemViewModel) =>
                          listItemViewModel!..update(viewModel),
                    ),
                  ],
                  child: SavedMessagesListItem(),
                );
              } else if (chatViewModel is DialogViewModel) {
                return SwipeableChatItem(
                  chatId: chatViewModel.chat.id,
                  onMute: () {},
                  onLock: () {},
                  onDelete: () {},
                  onArchive: () {},
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider<ChatViewModel>.value(
                        value: chatViewModel,
                      ),
                      ChangeNotifierProvider<DialogViewModel>.value(
                        value: chatViewModel,
                      ),
                      ChangeNotifierProxyProvider<DialogViewModel,
                          DialogListItemViewModel>(
                        create: (_) => DialogListItemViewModel(),
                        update: (_, viewModel, listItemViewModel) =>
                            listItemViewModel!..update(viewModel),
                      ),
                    ],
                    child: DialogListItem(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}

