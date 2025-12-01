import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:exchats/core/assets/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:exchats/core/di/locator.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:exchats/features/user/presentation/store/user_store.dart';
import 'package:exchats/features/auth/presentation/store/auth_store.dart';

import 'package:exchats/features/call/presentation/ui/calls/calls_screen.dart';
import 'package:exchats/features/chat/presentation/ui/chats/chats_screen.dart';
import 'package:exchats/features/contacts/presentation/ui/contacts/contacts_screen.dart';
import 'package:exchats/features/profile/presentation/ui/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final UserStore _userStore;

  @override
  void initState() {
    super.initState();
    _userStore = locator<UserStore>();
    final authStore = locator<AuthStore>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authStore.currentUserId != null) {
        _userStore.watchUser(authStore.currentUserId!);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ChatsScreen(),
          CallsScreen(),
          ContactsScreen(),
          ProfileScreen(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: AppBottomNavBar(
        items: _buildBottomNavBarItems(),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

List<AppBottomNavBarItem> _buildBottomNavBarItems() {
  return [
    AppBottomNavBarItem(
      icon: Assets.icons.chat.svg(width: 24, height: 24),
      label: 'chats',
      badge: 19,
    ),
    AppBottomNavBarItem(
      icon: Assets.icons.call.svg(width: 24, height: 24),
      label: 'calls',
      badge: 9,
    ),
    AppBottomNavBarItem(
      icon: Assets.icons.users.svg(width: 24, height: 24),
      label: 'contacts',
    ),
    AppBottomNavBarItem(
      icon: Assets.icons.profile.svg(width: 24, height: 24),
      label: 'profile',
    ),
  ];
}

class AppBottomNavBarItem {
  const AppBottomNavBarItem({
    required this.icon,
    required this.label,
    this.badge,
  });

  final Widget icon;
  final String label;
  final int? badge;
}

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppBottomNavBarItem> items;
  final int currentIndex;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return _buildBottomNavBar();
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 32),
          decoration: BoxDecoration(
            color: AppColors.subSurface.withValues(alpha: 0.7),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...items.mapIndexed(
                  (index, item) => AppBottomNavBarItemWidget(
                    icon: items[index].icon,
                    label: items[index].label,
                    isSelected: currentIndex == index,
                    badge: items[index].badge,
                    onTap: () => onTap(index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBottomNavBarItemWidget extends StatelessWidget {
  const AppBottomNavBarItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final Widget icon;
  final String label;
  final bool isSelected;
  final int? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        color: Colors.transparent,
        duration: const Duration(milliseconds: 300),
        height: 40,
        width: 40,
        child: Stack(
          children: [
            Center(child: icon),
            if (isSelected)
              Positioned(
                bottom: 0,
                left: 8,
                right: 8,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                ),
              ),
            if (badge != null)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18.0,
                    minHeight: 18.0,
                  ),
                  child: Center(
                    child: Text(
                      badge.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
