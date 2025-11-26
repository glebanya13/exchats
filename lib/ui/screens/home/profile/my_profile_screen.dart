import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:exchats/locator.dart';
import 'package:exchats/presentation/store/user_store.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userStore = locator<UserStore>();
    final user = userStore.user;
    final userName = user != null
        ? '${user.firstName} ${user.lastName}'.trim()
        : 'Артём';
    final phoneNumber = userStore.formattedPhoneNumber ?? user?.phoneNumber ?? '+7 (909) 844-12-23';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: const Color(0xFF62697B)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16.0),

            Container(
              width: 78.0,
              height: 78.0,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/profile/user.svg',
                  width: 39.0,
                  height: 39.0,
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            Text(
              userName,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),

            Text(
              'В сети',
              style: TextStyle(
                fontSize: 16.0,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 32.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildDetailCard(
                    label: 'Телефон',
                    value: phoneNumber,
                    valueColor: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 8.0),
                  _buildDetailCard(
                    label: 'О себе',
                    value: 'БИО',
                    valueColor: Colors.black,
                    valueFontWeight: FontWeight.normal,
                  ),
                  const SizedBox(height: 8.0),
                  _buildDetailCard(
                    label: 'Имя пользователя',
                    value: '@Art_26',
                    valueColor: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 8.0),
                  _buildDetailCard(
                    label: 'Почта',
                    value: 'qwerty@mail.ru',
                    valueColor: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String label,
    required String value,
    required Color valueColor,
    FontWeight valueFontWeight = FontWeight.normal,
  }) {
    return Container(
      height: 75.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: valueColor,
                    fontWeight: valueFontWeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

