import 'package:flutter/material.dart';

class SwipeableChatItem extends StatelessWidget {
  final Widget child;
  final String chatId;
  final VoidCallback? onMute;
  final VoidCallback? onLock;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;

  const SwipeableChatItem({
    Key? key,
    required this.child,
    required this.chatId,
    this.onMute,
    this.onLock,
    this.onDelete,
    this.onArchive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(chatId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {

        return false;
      },
      background: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildActionButton(
              icon: Icons.notifications_off,
              color: Colors.orange,
              onTap: onMute ?? () {},
            ),
            _buildActionButton(
              icon: Icons.lock,
              color: Colors.blue,
              onTap: onLock ?? () {},
            ),
            _buildActionButton(
              icon: Icons.delete,
              color: Colors.red,
              onTap: onDelete ?? () {},
            ),
            _buildActionButton(
              icon: Icons.archive,
              color: Colors.grey,
              onTap: onArchive ?? () {},
            ),
          ],
        ),
      ),
      onDismissed: (direction) {


      },
      child: child,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.0,
        color: color,
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 24.0,
          ),
        ),
      ),
    );
  }
}

