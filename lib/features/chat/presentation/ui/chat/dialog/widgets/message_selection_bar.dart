import 'package:flutter/material.dart';

class MessageSelectionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback? onReply;
  final VoidCallback? onForward;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;

  const MessageSelectionBar({
    Key? key,
    required this.selectedCount,
    this.onReply,
    this.onForward,
    this.onCopy,
    this.onDelete,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          InkWell(
            onTap: onReply,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.reply,
                  color: Colors.grey[700],
                  size: 24.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Ответить',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: onForward,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: Colors.grey[700],
                  size: 24.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Переслать',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

