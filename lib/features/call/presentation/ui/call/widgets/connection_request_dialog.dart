import 'package:flutter/material.dart';

class ConnectionRequestDialog extends StatelessWidget {
  final String userName;
  final VoidCallback? onAllow;
  final VoidCallback? onDeny;

  const ConnectionRequestDialog({
    Key? key,
    required this.userName,
    this.onAllow,
    this.onDeny,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String userName,
    VoidCallback? onAllow,
    VoidCallback? onDeny,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConnectionRequestDialog(
        userName: userName,
        onAllow: onAllow,
        onDeny: onDeny,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Запрос на подключение',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.displayLarge!.color,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Пользователь $userName желает присоединиться к звонку',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onDeny != null) onDeny!();
                  },
                  child: Text(
                    'Запретить',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onAllow != null) onAllow!();
                  },
                  child: Text(
                    'Разрешить',
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
