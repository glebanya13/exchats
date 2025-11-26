import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CallLinkDialog extends StatelessWidget {
  final String _callLink = 'exchats.com/IDTE233SJJmmdksss';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.black,
                      iconSize: 24.0,
                    ),
                  ],
                ),
              ),

              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF1677FF),
                  shape: BoxShape.circle,
                ),
                child: Transform.rotate(
                  angle: 0.785398, 
                  child: const Icon(
                    Icons.link,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              const Text(
                'Ссылка на звонок',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Каждый пользователь exchats сможет присоединиться к звонку по этой ссылке',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _callLink,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _callLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ссылка скопирована')),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _callLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ссылка скопирована')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1677FF),
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Скопировать',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1677FF),
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Поделиться',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
