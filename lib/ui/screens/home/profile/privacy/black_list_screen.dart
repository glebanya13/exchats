import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlackListScreen extends StatelessWidget {
  const BlackListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Text(
              '3 заблокированных пользователя',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildBlockedUser(
                  name: 'Артём',
                  phoneNumber: '+7 954 232 12 23',
                  avatarColor: Color(0xFFE57373),
                ),
                const SizedBox(height: 8.0),
                _buildBlockedUser(
                  name: 'Дмитрий',
                  phoneNumber: '+7 954 232 12 24',
                  avatarColor: Color(0xFFA1887F),
                ),
                const SizedBox(height: 8.0),
                _buildBlockedUser(
                  name: 'Олег',
                  phoneNumber: '+7 954 232 12 25',
                  avatarColor: Color(0xFF81C784),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedUser({
    required String name,
    required String phoneNumber,
    required Color avatarColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/profile/user.svg',
                width: 24.0,
                height: 24.0,
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  phoneNumber,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.grey[600],
            ),
            onSelected: (value) {
              if (value == 'unblock') {
                // Handle unblock action
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'unblock',
                child: Text('Разблокировать'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

