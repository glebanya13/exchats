import 'package:flutter/material.dart';

class DeleteMessageDialog extends StatefulWidget {
  const DeleteMessageDialog({Key? key}) : super(key: key);

  @override
  State<DeleteMessageDialog> createState() => _DeleteMessageDialogState();
}

class _DeleteMessageDialogState extends State<DeleteMessageDialog> {
  bool _deleteForEveryone = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Text(
        'Удалить сообщение',
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Вы точно хотите удалить это сообщение?',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: () {
              setState(() {
                _deleteForEveryone = !_deleteForEveryone;
              });
            },
            child: Row(
              children: [
                Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _deleteForEveryone
                          ? const Color(0xFF1677FF)
                          : Colors.grey[400]!,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                    color: _deleteForEveryone
                        ? const Color(0xFF1677FF)
                        : Colors.transparent,
                  ),
                  child: _deleteForEveryone
                      ? const Icon(
                          Icons.check,
                          size: 14.0,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12.0),
                const Text(
                  'Также удалить для всех',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Отмена',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.normal,
              color: Color(0xFF1677FF),
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_deleteForEveryone),
          child: const Text(
            'Удалить',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.normal,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
