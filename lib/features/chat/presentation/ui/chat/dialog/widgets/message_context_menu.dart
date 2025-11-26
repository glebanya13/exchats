import 'package:flutter/material.dart';
import '../../../../../domain/entity/message_entity.dart';

class MessageContextMenu {
  static void show(
    BuildContext context,
    MessageEntity message, {
    VoidCallback? onReply,
    VoidCallback? onCopy,
    VoidCallback? onForward,
    VoidCallback? onDelete,
    VoidCallback? onSelect,
  }) {
    final size = MediaQuery.of(context).size;
    final position = RelativeRect.fromLTRB(
      size.width * 0.3,
      size.height * 0.4,
      size.width * 0.3,
      size.height * 0.4,
    );

    showMenu(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      items: [
        _MenuItem(
          icon: Icons.reply,
          label: 'Ответить',
          onTap: onReply,
        ),
        _MenuItem(
          icon: Icons.copy,
          label: 'Копировать',
          onTap: onCopy,
        ),
        _MenuItem(
          icon: Icons.forward,
          label: 'Переслать',
          onTap: onForward,
        ),
        _MenuItem(
          icon: Icons.check_circle_outline,
          label: 'Выбрать',
          onTap: onSelect,
        ),
        _MenuItem(
          icon: Icons.delete,
          label: 'Удалить',
          color: Colors.red,
          onTap: onDelete,
        ),
      ],
    );
  }
}

class _MenuItem extends PopupMenuItem<void> {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  _MenuItem({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  }) : super(
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  if (onTap != null) {
                    Future.delayed(Duration(milliseconds: 100), onTap);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color: color ?? theme.textTheme.displayLarge!.color,
                        size: 20.0,
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        label,
                        style: TextStyle(
                          color: color ?? theme.textTheme.displayLarge!.color,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
}

