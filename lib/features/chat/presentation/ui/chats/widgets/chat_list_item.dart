import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entity/chat_entity.dart';
import '../../../../domain/entity/message_entity.dart';
import '../../../../../../core/di/locator.dart';
import '../../../store/chat_store.dart';
import '../../../../../../features/user/presentation/store/user_store.dart';
import '../../../../../../features/auth/presentation/store/auth_store.dart';
import 'package:intl/intl.dart';

class ChatListItem extends StatelessWidget {
  final ChatEntity chat;

  const ChatListItem({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatStore = locator<ChatStore>();
    final authStore = locator<AuthStore>();
    final currentUserId = authStore.currentUserId ?? '';
    
    final isSavedMessages = chat.type == 'saved_messages';
    final isDialog = chat.type == 'dialog';
    final isGroup = chat.type == 'group';
    
    String? otherUserId;
    if (isDialog) {
      otherUserId = chat.users.firstWhere(
        (userId) => userId != currentUserId,
        orElse: () => '',
      );
    }
    
    return InkWell(
      onTap: () {
        context.push('/chat/${chat.id}');
      },
      child: Container(
        height: 72.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: isGroup 
                    ? Colors.grey[300] 
                    : Colors.purple.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isGroup
                    ? Text(
                        '#',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: Colors.purple,
                        size: 28.0,
                      ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getChatTitle(chat, otherUserId),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) {
                          final lastMessage = chatStore.lastMessages[chat.id];
                          return _buildLastMessageTime(lastMessage);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(
                        child: Observer(
                          builder: (_) {
                            final lastMessage = chatStore.lastMessages[chat.id];
                            return _buildLastMessagePreview(lastMessage);
                          },
                        ),
                      ),
                      Observer(
                        builder: (_) {
                          final lastMessage = chatStore.lastMessages[chat.id];
                          final unreadCount = _getUnreadCount(chat, lastMessage);
                          if (unreadCount > 0) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1677FF),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20.0,
                                minHeight: 20.0,
                              ),
                              child: Center(
                                child: Text(
                                  '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getChatTitle(ChatEntity chat, String? otherUserId) {
    if (chat.type == 'saved_messages') {
      return 'Избранное';
    } else if (chat.type == 'group') {
      return 'Группа ${chat.id}';
    } else if (otherUserId != null && otherUserId.isNotEmpty) {
      return 'Пользователь $otherUserId';
    }
    return 'Чат ${chat.id}';
  }

  Widget _buildLastMessageTime(MessageEntity? lastMessage) {
    String timeText = '';
    if (lastMessage != null) {
      final now = DateTime.now();
      final messageDate = lastMessage.createdAt;
      final difference = now.difference(messageDate);

      if (difference.inDays == 0) {
        timeText = DateFormat('HH:mm').format(messageDate);
      } else if (difference.inDays == 1) {
        timeText = 'Вчера';
      } else if (difference.inDays < 7) {
        timeText = '${difference.inDays} дн.';
      } else {
        timeText = DateFormat('dd.MM').format(messageDate);
      }
    }

    return Container(
      width: 48.0,
      margin: const EdgeInsets.only(left: 6.0),
      child: Text(
        timeText,
        maxLines: 1,
        textAlign: TextAlign.end,
        style: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.normal,
          color: Color.fromARGB(255, 130, 143, 152),
        ),
      ),
    );
  }

  Widget _buildLastMessagePreview(MessageEntity? lastMessage) {
    String previewText = 'Нет сообщений';
    if (lastMessage != null) {
      if (lastMessage.type == 'call') {
        previewText = '📞 Звонок';
      } else if (lastMessage.type == 'video_call') {
        previewText = '📹 Видеозвонок';
      } else {
        previewText = lastMessage.text;
      }
    }

    return Text(
      previewText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Color.fromARGB(255, 130, 143, 152),
      ),
    );
  }

  int _getUnreadCount(ChatEntity chat, MessageEntity? lastMessage) {
    return chat.messageCounter;
  }
}
