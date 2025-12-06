import 'package:flutter/material.dart';
import 'package:exchats/core/constants/app_strings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../domain/entity/message_entity.dart';
import '../../../../../../features/user/domain/entity/user_entity.dart';
import '../../../../domain/entity/chat_entity.dart';
import '../shared_widgets/message_input.dart';
import 'package:exchats/core/widgets/appbar_icon_button.dart';
import '../../../../../../core/di/locator.dart';
import '../../../../../../features/auth/presentation/store/auth_store.dart';
import '../../../store/message_store.dart';
import '../../../store/chat_store.dart';
import '../../../../../../features/user/domain/usecase/user_usecase.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:exchats/core/util/last_seen_formatter.dart';
import 'package:exchats/core/constants/app_colors.dart';

import 'widgets/message_bubble.dart';
import 'widgets/message_selection_bar.dart';
import 'widgets/message_context_menu.dart';
import 'widgets/typing_indicator.dart';
import 'widgets/delete_message_dialog.dart';

class DialogArguments {
  DialogArguments({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.dialogUserId,
  });

  final String id;
  final String title;
  final MessageEntity lastMessage;
  final String dialogUserId;
}

class DialogScreen extends StatefulWidget {
  final String chatId;

  const DialogScreen({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen>
    with WidgetsBindingObserver {
  final GlobalKey<AnimatedListState> _messagesListKey = GlobalKey();
  final Set<String> _selectedMessageIds = {};
  final Map<String, MessageEntity> _messagesMap = {};
  final Map<String, UserEntity?> _usersMap = {};
  MessageEntity? _replyToMessage;
  UserEntity? _replyToUser;
  bool _isSelectionMode = false;

  late final MessageStore _messageStore;
  late final ChatStore _chatStore;
  late final AuthStore _authStore;

  ChatEntity? _currentChat;
  UserEntity? _otherUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _messageStore = locator<MessageStore>();
    _chatStore = locator<ChatStore>();
    _authStore = locator<AuthStore>();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (_authStore.currentUser == null) {
        await _authStore.checkAuthStatus();
      }
      
      _loadChatInfo();
      _messageStore.watchMessages(widget.chatId);
    });
  }

  Future<void> _loadChatInfo() async {
    final chat = await _chatStore.getChatById(widget.chatId);
    if (chat != null) {
      setState(() {
        _currentChat = chat;
      });

      if (chat.type == 'dialog') {
        final currentUserId = _authStore.currentUserId ?? '';
        final otherUserId = chat.participantUserIds.firstWhere(
          (userId) => userId != currentUserId,
          orElse: () => '',
        );
        if (otherUserId.isNotEmpty) {
          try {
            final userUseCase = locator<UserUseCase>();
            final user = await userUseCase.getUserById(otherUserId);
            setState(() {
              _otherUser = user;
            });
          } catch (e) {}
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    if (_isSelectionMode) {
      setState(() {
        _isSelectionMode = false;
        _selectedMessageIds.clear();
      });
      return true;
    }
    context.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _isSelectionMode
          ? _buildSelectionAppBar(theme)
          : (_currentChat?.type == 'group'
              ? _buildGroupAppBar(theme)
              : _buildDialogAppBar(theme)),
      body: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            color: Colors.white,
          ),
          Column(
            children: <Widget>[
              _buildMessageList(),
              if (_isSelectionMode)
                MessageSelectionBar(
                  selectedCount: _selectedMessageIds.length,
                  onReply: () {
                    if (_selectedMessageIds.length == 1) {
                      final messageId = _selectedMessageIds.first;
                      final message = _messagesMap[messageId];
                      setState(() {
                        _replyToMessage = message;
                        _replyToUser = message?.userId != null 
                            ? _usersMap[message!.userId!] 
                            : null;
                        _isSelectionMode = false;
                        _selectedMessageIds.clear();
                      });
                    }
                  },
                  onForward: () {
                    _exitSelectionMode();
                  },
                  onCopy: () {
                    _copySelectedMessages();
                  },
                  onDelete: () {
                    _deleteSelectedMessages();
                  },
                  onCancel: _exitSelectionMode,
                )
              else
                MessageInput(
                  key: const ValueKey('message_input'),
                  replyToMessage: _replyToMessage,
                  replyToUser: _replyToUser,
                  onReplyCancel: () {
                    setState(() {
                      _replyToMessage = null;
                      _replyToUser = null;
                    });
                  },
                  onSend: (text, replyTo) async {
                    if (text.trim().isEmpty) return;

                    // Проверяем и загружаем текущего пользователя
                    UserEntity? currentUser = _authStore.currentUser;
                    if (currentUser == null) {
                      await _authStore.checkAuthStatus();
                      currentUser = _authStore.currentUser;
                    }

                    if (currentUser == null) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Пользователь не авторизован')),
                        );
                      }
                      return;
                    }

                    final currentUserId = currentUser.id;

                    final message = MessageEntity(
                      id: '0',
                      type: 'text',
                      fileName: null,
                      metadata: null,
                      userId: currentUserId,
                      insertedAt: DateTime.now(),
                      content: text,
                      editedAt: null,
                      encrypted: false,
                      fileUrl: null,
                      guestName: null,
                      replyTo: replyTo != null
                          ? {
                              'id': replyTo.id,
                              'content': replyTo.content,
                              'userId': replyTo.userId,
                            }
                          : null,
                    );

                    try {
                      await _messageStore.sendMessage(widget.chatId, message);
                      setState(() {
                        _replyToMessage = null;
                        _replyToUser = null;
                      });
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка отправки сообщения: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSelectionAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: AppBarIconButton(
        icon: Icons.close,
        iconColor: Colors.black87,
        onTap: _exitSelectionMode,
      ),
      title: Text(
        '${_selectedMessageIds.length}',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 17.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        AppBarIconButton(
          onTap: () {
            _exitSelectionMode();
          },
          icon: Icons.arrow_forward,
          iconSize: 24.0,
          iconColor: Colors.grey.shade600,
        ),
        AppBarIconButton(
          onTap: _copySelectedMessages,
          icon: Icons.copy,
          iconSize: 24.0,
          iconColor: Colors.grey.shade600,
        ),
        AppBarIconButton(
          onTap: () {
            _exitSelectionMode();
          },
          icon: Icons.delete,
          iconSize: 24.0,
          iconColor: Colors.red,
        ),
      ],
    );
  }

  PreferredSizeWidget _buildDialogAppBar(ThemeData theme) {
    final userName = _otherUser != null
        ? (_otherUser!.name.isNotEmpty
            ? _otherUser!.name
            : (_otherUser!.username.isNotEmpty
                ? '@${_otherUser!.username}'
                : 'Пользователь ${_otherUser!.id}'))
        : 'Пользователь';
    final isOnline = LastSeenFormatter.isOnline(_otherUser?.lastSeenAt);
    final userStatus = _otherUser == null
        ? '—'
        : isOnline
            ? AppStrings.online
            : LastSeenFormatter.format(_otherUser!.lastSeenAt);
    final userId = _otherUser?.id ?? '';

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 8.0,
      title: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (userId.isNotEmpty) {
                context.push(
                  '/user_profile?userId=$userId&userName=${Uri.encodeComponent(userName)}&userStatus=${Uri.encodeComponent(userStatus)}',
                );
              }
            },
            child: Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/profile/user.svg',
                  width: 24.0,
                  height: 24.0,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (userId.isNotEmpty) {
                  context.push(
                    '/user_profile?userId=$userId&userName=${Uri.encodeComponent(userName)}&userStatus=${Uri.encodeComponent(userStatus)}',
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      userStatus,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: isOnline ? AppColors.primary : Colors.grey[600]!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      leading: AppBarIconButton(
        icon: Icons.arrow_back,
        iconColor: Colors.black87,
        onTap: () => context.pop(),
      ),
      actions: <Widget>[
        AppBarIconButton(
          onTap: () {
            if (userId.isNotEmpty) {
              context.push(
                '/active_call?userId=$userId&userName=${Uri.encodeComponent(userName)}&isVideoCall=false',
              );
            }
          },
          icon: Icons.phone,
          iconSize: 24.0,
          iconColor: Colors.grey.shade600,
        ),
        PopupMenuButton<String>(
          icon: Transform.rotate(
            angle: 1.5708,
            child: Icon(Icons.more_vert, color: Colors.grey.shade600, size: 24.0),
          ),
          onSelected: (value) async {
            if (value == 'delete_chat') {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Удалить чат'),
                  content: const Text('Вы уверены, что хотите удалить этот чат?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Удалить'),
                    ),
                  ],
                ),
              );
              if (result == true && mounted) {
                try {
                  await _chatStore.deleteChat(widget.chatId);
                  if (mounted) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Чат удален')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка удаления чата: ${e.toString()}')),
                    );
                  }
                }
              }
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'search',
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[700], size: 20.0),
                  const SizedBox(width: 12.0),
                  Text(
                    'Поиск',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'disable_notifications',
              child: Row(
                children: [
                  Icon(Icons.notifications_off, color: Colors.grey[700], size: 20.0),
                  const SizedBox(width: 12.0),
                  Text(
                    'Отключить уведомления',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete_chat',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20.0),
                  const SizedBox(width: 12.0),
                  Text(
                    'Удалить чат',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  PreferredSizeWidget _buildGroupAppBar(ThemeData theme) {
    final groupName =
        _currentChat != null ? 'Группа ${_currentChat!.id}' : 'Группа';

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 8.0,
      title: GestureDetector(
        onTap: () {
          context.push(
            '/group_profile?groupId=${widget.chatId}&groupName=${Uri.encodeComponent(groupName)}',
          );
        },
        child: Row(
          children: <Widget>[
            Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '#',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      groupName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      'Группа',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      automaticallyImplyLeading: false,
      leading: AppBarIconButton(
        icon: Icons.arrow_back,
        iconColor: Colors.black87,
        onTap: () => context.pop(),
      ),
      actions: <Widget>[
        AppBarIconButton(
          onTap: () {},
          icon: Icons.phone,
          iconSize: 24.0,
          iconColor: Colors.grey.shade600,
        ),
        PopupMenuButton<String>(
          icon: Transform.rotate(
            angle: 1.5708,
            child:
                Icon(Icons.more_vert, color: Colors.grey.shade600, size: 24.0),
          ),
          onSelected: (value) async {
            if (value == 'leave_group') {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Выйти из группы'),
                  content: const Text('Вы уверены, что хотите выйти из этой группы?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Выйти'),
                    ),
                  ],
                ),
              );
              if (result == true && mounted) {
                try {
                  await _chatStore.leaveChat(widget.chatId);
                  if (mounted) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Вы вышли из группы')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка выхода из группы: ${e.toString()}')),
                    );
                  }
                }
              }
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'video_call',
              child: Row(
                children: [
                  Icon(Icons.videocam, color: Colors.grey[700], size: 20.0),
                  const SizedBox(width: 12.0),
                  Text(
                    'Видеозвонок',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'search',
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[700], size: 20.0),
                  const SizedBox(width: 12.0),
                  Text(
                    'Поиск',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'disable_notifications',
              child: Row(
                children: [
                  Icon(Icons.notifications_off,
                      color: Colors.grey[700], size: 20.0),
                  const SizedBox(width: 12.0),
                  Text(
                    'Отключить уведомления',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'leave_group',
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.red, size: 20.0),
                  const SizedBox(width: 12.0),
                  Text(
                    'Выйти из группы',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return Observer(
      builder: (_) {
        final currentUserId = _authStore.currentUserId ?? '';
        final currentUser = _authStore.currentUser;
        final effectiveUserId = (currentUser?.id ?? currentUserId).toString();
        
        final messages = _messageStore.messages.toList();
        messages.sort((a, b) => a.insertedAt.compareTo(b.insertedAt));

        _messagesMap.clear();
        for (var msg in messages) {
          _messagesMap[msg.id] = msg;
        }

        return Expanded(
          child: RawScrollbar(
            thumbColor: Colors.black26,
            thickness: 4.0,
            child: ListView.builder(
              key: _messagesListKey,
              controller: ScrollController(),
              itemCount: messages.length + 1,
              reverse: true,
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isDialog = true;
                  UserEntity? typingUser;
                  if (!isDialog && messages.isNotEmpty) {
                    final lastMessage = messages.first;
                    if (lastMessage.userId != null && lastMessage.userId != effectiveUserId) {
                      typingUser = _usersMap[lastMessage.userId];
                    }
                  }
                  return TypingIndicator(
                    typingUser: typingUser,
                    showAvatar: !isDialog && typingUser != null,
                  );
                }
                final messageIndex = messages.length - index;
                if (messageIndex < 0 || messageIndex >= messages.length) {
                  return const SizedBox.shrink();
                }
                final message = messages[messageIndex];
                final messageUserId = message.userId?.toString() ?? '';
                final isOwnMessage = messageUserId.isNotEmpty && 
                    messageUserId == effectiveUserId;
                final previousMessage = messageIndex < messages.length - 1 
                    ? messages[messageIndex + 1] 
                    : null;
                final showAvatar = previousMessage == null ||
                    previousMessage.userId != message.userId ||
                    message.insertedAt
                            .difference(previousMessage.insertedAt)
                            .inMinutes >
                        5;

                MessageEntity? replyToMsg;
                UserEntity? replyToUser;
                if (message.replyTo != null) {
                  final replyToId = message.replyTo?['id']?.toString();
                  if (replyToId != null) {
                    replyToMsg = _messagesMap[replyToId];
                    if (replyToMsg != null && replyToMsg.userId != null) {
                      replyToUser = _usersMap[replyToMsg.userId];
                    }
                  }
                }

                UserEntity? messageUser = message.userId != null 
                    ? _usersMap[message.userId] 
                    : null;

                final isDialog = true;
                final shouldShowAvatar = isDialog ? false : !isOwnMessage;

                return MessageBubble(
                  message: message,
                  replyToMessage: replyToMsg,
                  replyToUser: replyToUser,
                  messageUser: messageUser,
                  isSelected: _selectedMessageIds.contains(message.id),
                  showAvatar: shouldShowAvatar,
                  isOwnMessage: isOwnMessage,
                  onTap: () {
                    if (_isSelectionMode) {
                      setState(() {
                        if (_selectedMessageIds.contains(message.id)) {
                          _selectedMessageIds.remove(message.id);
                        } else {
                          _selectedMessageIds.add(message.id);
                        }
                        if (_selectedMessageIds.isEmpty) {
                          _isSelectionMode = false;
                        }
                      });
                    }
                  },
                  onLongPress: () {
                    _showMessageContextMenu(context, message);
                  },
                  onSwipeReply: () {
                    setState(() {
                      _replyToMessage = message;
                      _replyToUser = messageUser;
                    });
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedMessageIds.clear();
    });
  }

  void _copySelectedMessages() {
    final selectedMessages = _selectedMessageIds
        .map((id) => _messagesMap[id])
        .where((msg) => msg != null)
        .map((msg) => msg!.text)
        .join('\n');

    Clipboard.setData(ClipboardData(text: selectedMessages));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Скопировано')),
    );
    _exitSelectionMode();
  }

  Future<void> _deleteSelectedMessages() async {
    if (_selectedMessageIds.isEmpty) return;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteMessageDialog(),
    );
    
    if (result == true && mounted) {
      try {
        for (final messageId in _selectedMessageIds) {
          await _messageStore.deleteMessage(widget.chatId, messageId);
        }
        _exitSelectionMode();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Сообщения удалены')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка удаления: ${e.toString()}')),
          );
        }
      }
    }
  }

  void _showMessageContextMenu(BuildContext context, MessageEntity message) {
    MessageContextMenu.show(
      context,
      message,
      onReply: () {
        setState(() {
          _replyToMessage = message;
        });
      },
      onCopy: () {
        Clipboard.setData(ClipboardData(text: message.text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Скопировано')),
        );
      },
      onForward: () {},
      onSelect: () {
        setState(() {
          _isSelectionMode = true;
          if (!_selectedMessageIds.contains(message.id)) {
            _selectedMessageIds.add(message.id);
          }
        });
      },
      onDelete: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => const DeleteMessageDialog(),
        );
        if (result == true && mounted) {
          try {
            await _messageStore.deleteMessage(widget.chatId, message.id);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Сообщение удалено')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка удаления: ${e.toString()}')),
              );
            }
          }
        }
      },
    );
  }
}
