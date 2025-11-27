import 'package:flutter/material.dart';
import 'package:exchats/core/constants/app_colors.dart';

class CallsPrivacyScreen extends StatefulWidget {
  const CallsPrivacyScreen({Key? key}) : super(key: key);

  @override
  _CallsPrivacyScreenState createState() => _CallsPrivacyScreenState();
}

class _CallsPrivacyScreenState extends State<CallsPrivacyScreen> {
  String _whoCanCall = 'Все';

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
                'Кто может звонить мне',
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
                selectedValue: _whoCanCall,
                onSelected: (value) {
                  setState(() {
                    _whoCanCall = value;
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
                title: 'Всегда запрещать',
                count: '3 человека',
                onTap: () {},
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
}
