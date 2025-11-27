import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:exchats/core/di/locator.dart';
import 'package:exchats/features/user/presentation/store/user_store.dart';
import 'package:exchats/features/user/domain/entity/user_entity.dart';
import 'package:exchats/features/auth/presentation/store/auth_store.dart';
import 'package:exchats/core/util/user_formatter.dart';
import 'package:exchats/core/constants/app_strings.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:exchats/core/util/last_seen_formatter.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userStore = locator<UserStore>();
    final authStore = locator<AuthStore>();

    return Observer(
      builder: (_) {
        final user = authStore.currentUser ?? userStore.user;
        final userName = UserFormatter.resolveDisplayName(user);
        final phoneNumber = UserFormatter.formatPhone(user?.phone);
        final statusText = user == null
            ? AppStrings.unknown
            : LastSeenFormatter.isOnline(user.lastSeenAt)
                ? AppStrings.online
                : LastSeenFormatter.format(user.lastSeenAt);
        final emailText = user != null && user.email.isNotEmpty
            ? user.email
            : AppStrings.unknown;

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
                icon: const Icon(Icons.edit, color: AppColors.iconGray),
                onPressed: user == null
                    ? null
                    : () => _showEditProfileSheet(
                          context,
                          userStore,
                          authStore,
                          user,
                        ),
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
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  statusText,
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
                        label: 'Имя пользователя',
                        value:
                            user?.username != null && user!.username.isNotEmpty
                                ? '@${user.username}'
                                : '—',
                        valueColor: theme.colorScheme.secondary,
                      ),
                      const SizedBox(height: 8.0),
                      _buildDetailCard(
                        label: 'Почта',
                        value: emailText,
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
      },
    );
  }

  Widget _buildDetailCard({
    required String label,
    required String value,
    required Color valueColor,
    FontWeight valueFontWeight = FontWeight.normal,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 75.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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

  void _showEditProfileSheet(
    BuildContext context,
    UserStore userStore,
    AuthStore authStore,
    UserEntity user,
  ) {
    userStore.user ??= user;
    final nameController = TextEditingController(text: user.name);
    final usernameController = TextEditingController(text: user.username);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        bool isSaving = false;
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 24.0,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Редактировать профиль',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixText: '@',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              final newName = nameController.text.trim();
                              final newUsername =
                                  usernameController.text.trim();
                              final sanitizedUsername =
                                  newUsername.startsWith('@')
                                      ? newUsername.substring(1)
                                      : newUsername;

                              if (newName.isEmpty ||
                                  sanitizedUsername.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Заполните имя и username полностью',
                                    ),
                                  ),
                                );
                                return;
                              }

                              setModalState(() {
                                isSaving = true;
                              });

                              try {
                                final updated = await userStore.updateProfile(
                                  name: newName,
                                  username: sanitizedUsername,
                                );
                                if (updated != null) {
                                  authStore.updateCurrentUser(updated);
                                  if (context.mounted) {
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Профиль обновлён'),
                                      ),
                                    );
                                  }
                                }
                              } catch (_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Не удалось обновить профиль. Попробуйте позже.',
                                      ),
                                    ),
                                  );
                                }
                              } finally {
                                if (ctx.mounted) {
                                  setModalState(() {
                                    isSaving = false;
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.white,
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Сохранить',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
