import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../domain/entity/message_entity.dart';
import '../../../../../../../features/user/domain/entity/user_entity.dart';
import '../../../../../../../core/di/locator.dart';
import '../../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../features/auth/presentation/store/auth_store.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final MessageEntity? replyToMessage;
  final UserEntity? replyToUser;
  final UserEntity? messageUser;
  final bool isSelected;
  final bool showAvatar;
  final bool isOwnMessage;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSwipeReply;

  const MessageBubble({
    Key? key,
    required this.message,
    this.replyToMessage,
    this.replyToUser,
    this.messageUser,
    this.isSelected = false,
    this.showAvatar = false,
    required this.isOwnMessage,
    this.onTap,
    this.onLongPress,
    this.onSwipeReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSystemMessage = message.type != 'text';

    if (isSystemMessage) {
      return _buildSystemMessage(context);
    }

    return Dismissible(
      key: Key('swipe_${message.id}'),
      direction: isOwnMessage
          ? DismissDirection.endToStart
          : DismissDirection.startToEnd,
      onDismissed: (direction) {
        if (onSwipeReply != null) {
          onSwipeReply!();
        }
      },
      confirmDismiss: (direction) async {
        if (onSwipeReply != null) {
          onSwipeReply!();
        }
        return false;
      },
      background: Container(
        alignment: isOwnMessage ? Alignment.centerLeft : Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(
          Icons.reply,
          color: theme.colorScheme.secondary,
          size: 24.0,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isOwnMessage ? 0.0 : 16.0,
            vertical: 4.0,
          ),
          color: isSelected
              ? theme.colorScheme.secondary.withOpacity(0.1)
              : Colors.transparent,
          child: Row(
            mainAxisAlignment:
                isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isSelected)
                Container(
                  width: 20.0,
                  height: 20.0,
                  margin: EdgeInsets.only(
                    right: 8.0,
                    left: isOwnMessage ? 0.0 : 0.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 0.1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 11.0,
                        height: 11.0,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isOwnMessage && showAvatar)
                Container(
                  width: 32.0,
                  height: 32.0,
                  margin: EdgeInsets.only(
                    right: 8.0,
                    left: isSelected ? 0.0 : 0.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/profile/user.svg',
                      width: 18.0,
                      height: 18.0,
                      colorFilter: const ColorFilter.mode(
                        Colors.purple,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              if (!isOwnMessage && !showAvatar && !isSelected)
                const SizedBox(width: 8.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: isOwnMessage
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isOwnMessage
                            ? const Color(0xFFDCF8C6)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.replyTo != null && replyToMessage != null)
                            _buildReplyQuote(context, theme, isOwnMessage),
                          SelectableText(
                            message.text,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                            ),
                            contextMenuBuilder: (context, editableTextState) {
                              return AdaptiveTextSelectionToolbar.buttonItems(
                                anchors: editableTextState.contextMenuAnchors,
                                buttonItems: <ContextMenuButtonItem>[
                                  ContextMenuButtonItem(
                                    label: 'Цитировать',
                                    onPressed: () {
                                      ContextMenuController.removeAny();
                                    },
                                  ),
                                  ContextMenuButtonItem(
                                    label: 'Копировать',
                                    onPressed: () {
                                      ContextMenuController.removeAny();
                                      final selection = editableTextState
                                          .currentTextEditingValue.selection;
                                      if (selection.isValid) {
                                        final text = editableTextState
                                            .currentTextEditingValue.text
                                            .substring(
                                          selection.start,
                                          selection.end,
                                        );
                                        Clipboard.setData(
                                            ClipboardData(text: text));
                                      }
                                    },
                                  ),
                                  ContextMenuButtonItem(
                                    label: 'Выбрать все',
                                    onPressed: () {
                                      editableTextState.selectAll(
                                          SelectionChangedCause.toolbar);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat('HH:mm').format(message.createdAt),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                              if (isOwnMessage) ...[
                                const SizedBox(width: 4.0),
                                Icon(
                                  message.read ? Icons.done_all : Icons.done,
                                  size: 14.0,
                                  color: message.read
                                      ? AppColors.primary
                                      : Colors.black54,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isOwnMessage && !showAvatar) const SizedBox(width: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyQuote(
      BuildContext context, ThemeData theme, bool isOwnMessage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isOwnMessage
            ? Colors.white.withOpacity(0.3)
            : const Color(0xFFDCF8C6),
        borderRadius: BorderRadius.circular(8.0),
        border: Border(
          left: BorderSide(
            color: isOwnMessage ? const Color(0xFF4CAF50) : AppColors.primary,
            width: 3.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            replyToUser?.name ?? 'User',
            style: TextStyle(
              color: isOwnMessage ? const Color(0xFF4CAF50) : AppColors.primary,
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            replyToMessage?.text ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(BuildContext context) {
    String systemText = message.text;
    IconData? systemIcon;

    if (message.type == 'call') {
      systemText = 'Звонок в ${DateFormat('HH:mm').format(message.createdAt)}';
      systemIcon = Icons.phone;
    } else if (message.type == 'video_call') {
      if (message.text.contains('начал')) {
        systemText =
            '${message.text} • Присоединились: ${message.participants?.join(', ') ?? ''}';
      } else if (message.text.contains('завершился')) {
        final duration = message.callDuration?.inMinutes ?? 0;
        systemText =
            'Видеозвонок завершился • Продолжительность: $duration минут';
      }
      systemIcon = Icons.videocam;
    } else if (message.type == 'group_created') {
      systemText = 'Группа создана';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (systemIcon != null) ...[
                    Icon(systemIcon, size: 16.0, color: Colors.black54),
                    const SizedBox(width: 8.0),
                  ],
                  Flexible(
                    child: Text(
                      systemText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            DateFormat('HH:mm').format(message.createdAt),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
