import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _showTextEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            // Message Notifications Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Уведомления о сообщениях',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildNotificationItem(
                    title: 'Личные чаты',
                    status: 'Вкл',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8.0),
                  _buildNotificationItem(
                    title: 'Группы',
                    status: 'Выкл',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            // In-app Notifications Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Уведомления в приложении',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildToggleItem(
                    title: 'Звук',
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildToggleItem(
                    title: 'Вибрация',
                    value: _vibrationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _vibrationEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildToggleItem(
                    title: 'Показывать текст',
                    value: _showTextEnabled,
                    onChanged: (value) {
                      setState(() {
                        _showTextEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String status,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF1677FF),
            ),
          ),
        ],
      ),
    );
  }
}

