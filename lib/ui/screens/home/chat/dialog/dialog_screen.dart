import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:exchats/models/message.dart';
import 'package:exchats/models/user_details.dart';
import 'package:exchats/services/auth_service.dart';
import 'package:exchats/services/user_service.dart';
import 'package:exchats/ui/screens/home/chat/shared_widgets/message_input.dart';
import 'package:exchats/ui/screens/home/chat/user_profile_screen.dart';
import 'package:exchats/ui/screens/home/chat/group_profile_screen.dart';
import 'package:exchats/ui/shared_widgets/appbar_icon_button.dart';
import 'package:exchats/ui/shared_widgets/rounded_avatar.dart';
import 'package:exchats/view_models/home/chats/dialog_viewmodel.dart';
import 'package:exchats/view_models/home/chats/group_viewmodel.dart';
import 'package:exchats/view_models/home/chats/chat_viewmodel.dart';
import 'package:exchats/ui/screens/home/call/active_call_screen.dart';
import 'package:exchats/locator.dart';

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
  final Message lastMessage;
  final String dialogUserId;
}

class DialogScreen extends StatefulWidget {
  const DialogScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen>
    with WidgetsBindingObserver {
  final GlobalKey<AnimatedListState> _messagesListKey = GlobalKey();
  final Set<String> _selectedMessageIds = {};
  final Map<String, Message> _messagesMap = {};
  final Map<String, UserDetails?> _usersMap = {};
  Message? _replyToMessage;
  UserDetails? _replyToUser;
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final chatViewModel = context.read<ChatViewModel>();
      if (chatViewModel is DialogViewModel) {
        chatViewModel.initialize();
      } else if (chatViewModel is GroupViewModel) {
        chatViewModel.initialize();
      }
    });
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
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = locator<AuthService>();
    final userService = locator<UserService>();

    return Scaffold(
      appBar: _isSelectionMode ? _buildSelectionAppBar(theme) : _buildNormalAppBar(theme, authService, userService),
      body: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            color: Colors.white,
          ),
          Column(
            children: <Widget>[
              _buildMessageList(userService, authService),
              if (_isSelectionMode)
                MessageSelectionBar(
                  selectedCount: _selectedMessageIds.length,
                  onReply: () {
                    if (_selectedMessageIds.length == 1) {
                      final messageId = _selectedMessageIds.first;
                      final message = _messagesMap[messageId];
                      setState(() {
                        _replyToMessage = message;
                        _replyToUser = _usersMap[message?.owner];
                        _isSelectionMode = false;
                        _selectedMessageIds.clear();
                      });
                      if (message != null && _replyToUser == null) {
                        userService.getUserById(id: message.owner).then((user) {
                          if (user != null && mounted) {
                            setState(() {
                              _usersMap[message.owner] = user;
                              _replyToUser = user;
                            });
                          }
                        });
                      }
                    }
                  },
                  onForward: () {
                    // TODO: Implement forward
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

  PreferredSizeWidget _buildNormalAppBar(ThemeData theme, AuthService authService, UserService userService) {
    final chatViewModel = context.read<ChatViewModel>();
    
    if (chatViewModel is DialogViewModel) {
      return _buildDialogAppBar(theme, chatViewModel);
    } else if (chatViewModel is GroupViewModel) {
      return _buildGroupAppBar(theme, chatViewModel);
    }
    
    return AppBar(title: const Text('Chat'));
  }

  PreferredSizeWidget _buildDialogAppBar(ThemeData theme, DialogViewModel model) {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 8.0,
        title: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => UserProfileScreen(
                      userId: model.dialogUserId,
                      userName: model.title,
                      userStatus: model.dialogUserOnlineStatus,
                    ),
                  ),
                );
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => UserProfileScreen(
                        userId: model.dialogUserId,
                        userName: model.title,
                        userStatus: model.dialogUserOnlineStatus,
                      ),
                    ),
                  );
                },
              child: Container(
                margin: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Selector<DialogViewModel, String>(
                      selector: (context, model) => model.title,
                      builder: (context, title, child) {
                        return Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                          ),
                        );
                      },
                    ),
                    Selector<DialogViewModel, String>(
                      selector: (context, model) =>
                          model.dialogUserOnlineStatus,
                      builder: (context, dialogUserOnlineStatus, child) {
                        return Text(
                          dialogUserOnlineStatus,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                              color: Color(0xFF1677FF),
                          ),
                        );
                      },
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
          onTap: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
        Consumer<DialogViewModel>(
          builder: (context, model, child) {
            return AppBarIconButton(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActiveCallScreen(
                      userId: model.dialogUserId,
                      userName: model.title,
                      isVideoCall: false,
                    ),
                  ),
                );
              },
              icon: Icons.phone,
              iconSize: 24.0,
              iconColor: Colors.grey.shade600,
            );
          },
        ),
          Transform.rotate(
            angle: 1.5708, // 90 degrees in radians
            child: AppBarIconButton(
              onTap: () {},
              icon: Icons.more_vert,
              iconSize: 24.0,
              iconColor: Colors.grey.shade600,
            ),
          ),
        ],
    );
  }

  PreferredSizeWidget _buildGroupAppBar(ThemeData theme, GroupViewModel model) {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 8.0,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: model,
                  child: ChangeNotifierProvider.value(
                    value: model as ChatViewModel,
                    child: GroupProfileScreen(
                      groupId: model.chat.id,
                      groupName: model.title,
                    ),
                  ),
                ),
              ),
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
                      Selector<GroupViewModel, String>(
                        selector: (context, model) => model.title,
                        builder: (context, title, child) {
                          return Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          );
                        },
                      ),
                      const Text(
                        'Группа',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF1677FF),
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
          onTap: () => Navigator.of(context).pop(),
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
              angle: 1.5708, // 90 degrees in radians
              child: Icon(Icons.more_vert, color: Colors.grey.shade600, size: 24.0),
            ),
            onSelected: (value) {
              if (value == 'video_call') {
              } else if (value == 'search') {
              } else if (value == 'disable_notifications') {
              } else if (value == 'leave_group') {
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


  Widget _buildMessageList(UserService userService, AuthService authService) {
    return Consumer<ChatViewModel>(
      builder: (context, chatViewModel, child) {
        List<Message> messages = [];
        if (chatViewModel is DialogViewModel) {
          messages = chatViewModel.messages;
        } else if (chatViewModel is GroupViewModel) {
          messages = chatViewModel.messages;
        }
        // Filter out empty messages
        messages = messages.where((msg) => msg.text.isNotEmpty || msg.type != MessageType.Text).toList();
        final currentUserId = authService.currentUserId ?? '';

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
              controller: chatViewModel is DialogViewModel 
                  ? (chatViewModel as DialogViewModel).scrollController
                  : (chatViewModel as GroupViewModel).scrollController,
              itemCount: messages.length + 1,
              reverse: true,
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isDialog = chatViewModel is DialogViewModel;
                  UserDetails? typingUser;
                  if (!isDialog && messages.isNotEmpty) {
                    final lastMessage = messages.first;
                    if (lastMessage.owner != currentUserId) {
                      typingUser = _usersMap[lastMessage.owner];
                    }
                  }
                  return TypingIndicator(
                    typingUser: typingUser,
                    showAvatar: !isDialog && typingUser != null,
                  );
                }
                final messageIndex = index - 1;
                final message = messages[messageIndex];
                final isOwnMessage = message.owner == currentUserId;
                final previousMessage =
                    index < messages.length - 1 ? messages[index + 1] : null;
                final showAvatar = previousMessage == null ||
                    previousMessage.owner != message.owner ||
                    message.createdAt.difference(previousMessage.createdAt).inMinutes > 5;

                Message? replyToMsg;
                UserDetails? replyToUser;
                if (message.replyTo != null) {
                  replyToMsg = _messagesMap[message.replyTo];
                  if (replyToMsg != null) {
                    replyToUser = _usersMap[replyToMsg.owner];
                    if (replyToUser == null) {
                      userService.getUserById(id: replyToMsg.owner).then((user) {
                        if (user != null) {
                          setState(() {
                            _usersMap[replyToMsg!.owner] = user;
                          });
                        }
                      });
                    }
                  }
                }

                UserDetails? messageUser = _usersMap[message.owner];
                if (messageUser == null) {
                  userService.getUserById(id: message.owner).then((user) {
                    if (user != null) {
                      setState(() {
                        _usersMap[message.owner] = user;
                      });
                    }
                  });
                }

                final isDialog = chatViewModel is DialogViewModel;
                final shouldShowAvatar = isDialog ? false : !isOwnMessage;
                
                return MessageBubble(
                  message: message,
                  replyToMessage: replyToMsg,
                  replyToUser: replyToUser,
                  messageUser: messageUser,
                  isSelected: _selectedMessageIds.contains(message.id),
                  showAvatar: shouldShowAvatar,
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
                      if (messageUser == null) {
                        userService.getUserById(id: message.owner).then((user) {
                          if (user != null && mounted) {
                            setState(() {
                              _usersMap[message.owner] = user;
                              _replyToUser = user;
                            });
                          }
                        });
                      }
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

  void _deleteSelectedMessages() {
    _exitSelectionMode();
  }

  void _showMessageContextMenu(
      BuildContext context, Message message) {
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
        if (result != null && mounted) {
          if (result) {
          } else {
          }
        }
      },
    );
  }
}
