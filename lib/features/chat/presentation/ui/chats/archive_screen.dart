import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:exchats/core/widgets/appbar_icon_button.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:exchats/core/constants/app_strings.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: AppBarIconButton(
          icon: Icons.arrow_back,
          iconColor: AppColors.black,
          onTap: () => context.pop(),
        ),
        title: const Text(
          'Архив',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Text(
          AppStrings.archiveEmpty,
          style: TextStyle(color: AppColors.grey(600), fontSize: 16.0),
        ),
      ),
    );
  }
}
