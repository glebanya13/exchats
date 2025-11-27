import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:exchats/core/widgets/appbar_icon_button.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: AppBarIconButton(
          icon: Icons.arrow_back,
          iconColor: Colors.black87,
          onTap: () => context.pop(),
        ),
        title: const Text(
          'Архив',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Архив пуст',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
