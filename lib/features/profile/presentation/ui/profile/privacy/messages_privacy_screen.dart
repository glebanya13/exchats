import 'package:flutter/material.dart';
import 'package:exchats/core/constants/app_colors.dart';

class MessagesPrivacyScreen extends StatefulWidget {
  const MessagesPrivacyScreen({Key? key}) : super(key: key);

  @override
  _MessagesPrivacyScreenState createState() => _MessagesPrivacyScreenState();
}

class _MessagesPrivacyScreenState extends State<MessagesPrivacyScreen> {
  String _whoCanSendMessages = 'Все';

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
        title: Text(
          'Кто может отправлять мне сообщения',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildOptionsCard(
                selectedValue: _whoCanSendMessages,
                onSelected: (value) {
                  setState(() {
                    _whoCanSendMessages = value;
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
}
