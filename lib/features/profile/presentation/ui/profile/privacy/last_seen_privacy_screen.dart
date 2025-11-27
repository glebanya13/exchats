import 'package:flutter/material.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';

class LastSeenPrivacyScreen extends StatefulWidget {
  const LastSeenPrivacyScreen({Key? key}) : super(key: key);

  @override
  _LastSeenPrivacyScreenState createState() => _LastSeenPrivacyScreenState();
}

class _LastSeenPrivacyScreenState extends State<LastSeenPrivacyScreen> {
  String _whoSeesOnline = 'Никто';
  bool _hideReadReceipts = true;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Кто видит, когда я в сети',
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
              child: _buildOptionsCard(
                selectedValue: _whoSeesOnline,
                onSelected: (value) {
                  setState(() {
                    _whoSeesOnline = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Исключения',
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
              child: _buildExceptionItem(
                title: 'Всегда показывать',
                count: '3 человека',
                onTap: () {},
              ),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildToggleItem(
                title: 'Скрывать время прочтения',
                value: _hideReadReceipts,
                onChanged: (value) {
                  setState(() {
                    _hideReadReceipts = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsCard({
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildOptionItem(
            title: 'Все',
            isSelected: selectedValue == 'Все',
            onTap: () => onSelected('Все'),
            showDivider: true,
          ),
          _buildOptionItem(
            title: 'Контакты',
            isSelected: selectedValue == 'Контакты',
            onTap: () => onSelected('Контакты'),
            showDivider: true,
          ),
          _buildOptionItem(
            title: 'Никто',
            isSelected: selectedValue == 'Никто',
            onTap: () => onSelected('Никто'),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                SizedBox(
                  width: 20.0,
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: AppColors.primary,
                          size: 20.0,
                        )
                      : null,
                ),
                const SizedBox(width: 12.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
            indent: 16.0,
            endIndent: 16.0,
          ),
      ],
    );
  }

  Widget _buildExceptionItem({
    required String title,
    required String count,
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
              count,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
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
              activeColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
