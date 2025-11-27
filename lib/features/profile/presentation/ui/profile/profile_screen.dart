import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:exchats/core/widgets/safe_svg_icon.dart';
import 'package:exchats/features/profile/presentation/ui/profile/business_account_screen.dart';
import 'package:exchats/features/profile/presentation/ui/profile/devices_screen.dart';
import 'package:exchats/features/profile/presentation/ui/profile/folders_screen.dart';
import 'package:exchats/features/profile/presentation/ui/profile/my_profile_screen.dart';
import 'package:exchats/features/profile/presentation/ui/profile/notifications_screen.dart';
import 'package:exchats/features/profile/presentation/ui/profile/privacy_screen.dart';
import 'package:exchats/core/di/locator.dart';
import 'package:exchats/features/user/presentation/store/user_store.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userStore = locator<UserStore>();
    final user = userStore.user;
    final userName = user != null
        ? '${user.firstName} ${user.lastName}'.trim()
        : 'Артём';
    final phoneNumber = userStore.formattedPhoneNumber ?? user?.phoneNumber ?? '+7 922 222 23 12';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32.0),
              Column(
                children: [
                  Container(
                    width: 96.0,
                    height: 96.0,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/profile/user.svg',
                        width: 48.0,
                        height: 48.0,
                        colorFilter: ColorFilter.mode(
                          Colors.purple,
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
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
              const SizedBox(height: 24.0),
              _buildListItem(
                context: context,
                iconAsset: 'assets/profile/add_photo.svg',
                iconColor: theme.colorScheme.secondary,
                title: 'Изменить фотографию',
                titleColor: theme.colorScheme.secondary,
                hasPlus: true,
              ),
              const SizedBox(height: 5.0),
              _buildListItem(
                context: context,
                iconAsset: 'assets/profile/user.svg',
                iconColor: Colors.purple,
                title: userName,
                badge: '24',
                applyColorToIcon: true,
              ),
              const SizedBox(height: 5.0),
              _buildListItem(
                context: context,
                iconAsset: 'assets/profile/plus.svg',
                iconColor: theme.colorScheme.secondary,
                title: 'Добавить аккаунт',
                titleColor: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 24.0),
              _buildListItem(
                context: context,
                iconAsset: 'assets/profile/profile.svg',
                iconColor: theme.colorScheme.secondary,
                title: 'Мой профиль',
                onTap: () {
                  context.push('/my_profile');
                },
              ),
              const SizedBox(height: 5.0),
              _buildListItem(
                context: context,
                iconAsset: 'assets/profile/notifications.svg',
                iconColor: Colors.red,
                title: 'Уведомления',
                onTap: () {
                  context.push('/notifications');
                },
              ),
              const SizedBox(height: 5.0),
              _buildListItem(
                context: context,
                iconAsset: 'assets/profile/folders.svg',
                iconColor: theme.colorScheme.secondary,
                title: 'Папки',
                onTap: () {
                  context.push('/folders');
                },
              ),
              const SizedBox(height: 5.0),
              _buildListItem(
                context: context,
                iconAsset: 'assets/profile/devices.svg',
                iconColor: Colors.orange,
                title: 'Устройства',
                onTap: () {
                  context.push('/devices');
                },
              ),
              const SizedBox(height: 5.0),
              _buildListItem(
                context: context,
                iconAsset: 'assets/profile/security.svg',
                iconColor: Colors.grey[600]!,
                title: 'Конфиденциальность',
                onTap: () {
                  context.push('/privacy');
                },
              ),
              const SizedBox(height: 24.0),
              _buildListItem(
                context: context,
                iconAsset: 'assets/profile/bussines.svg',
                iconColor: Colors.green,
                title: 'Создать бизнес аккаунт',
                onTap: () {
                  context.push('/business_account');
                },
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem({
    required BuildContext context,
    IconData? icon,
    String? iconAsset,
    required Color iconColor,
    required String title,
    Color? titleColor,
    String? badge,
    bool hasPlus = false,
    bool applyColorToIcon = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      height: 60.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    iconAsset != null
                        ? SvgPicture.asset(
                            iconAsset,
                            width: 24.0,
                            height: 24.0,
                            colorFilter: applyColorToIcon
                                ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                                : null,
                            placeholderBuilder: (context) => Icon(
                              icon ?? Icons.circle,
                              color: iconColor,
                              size: 24.0,
                            ),
                          )
                        : Icon(
                            icon ?? Icons.circle,
                            color: iconColor,
                            size: 24.0,
                          ),
                    if (hasPlus)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 8.0,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: titleColor ?? Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                    color: Colors.grey[400],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
