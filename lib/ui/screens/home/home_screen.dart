import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:exchats/ui/shared_widgets/safe_svg_icon.dart';
import 'package:exchats/view_models/home/home_viewmodel.dart';
import 'package:exchats/view_models/home/chats/chats_viewmodel.dart';
import 'package:exchats/view_models/home/contacts/contacts_viewmodel.dart';

import 'calls/calls_screen.dart';
import 'chats/chats_screen.dart';
import 'contacts/contacts_screen.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => ChatsViewModel(),
      child: ChatsScreen(),
    ),
    const CallsScreen(),
    ChangeNotifierProvider(
      create: (_) => ContactsViewModel(),
      child: const ContactsScreen(),
    ),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HomeViewModel>().changeOnlineStatus(true);
    } else if (state == AppLifecycleState.inactive) {
      context.read<HomeViewModel>().changeOnlineStatus(false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<HomeViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: theme.colorScheme.secondary,
            unselectedItemColor: theme.textTheme.bodyLarge?.color,
            items: [
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SafeSvgIcon(
                      assetPath: 'assets/bottom/message.svg',
                      width: 24.0,
                      height: 24.0,
                      color: _currentIndex == 0
                          ? theme.colorScheme.secondary
                          : (theme.textTheme.bodyLarge?.color ?? Colors.grey),
                      fallback: Icon(
                        _currentIndex == 0 ? Icons.chat_bubble : Icons.chat_bubble_outline,
                        size: 24.0,
                        color: _currentIndex == 0
                            ? theme.colorScheme.secondary
                            : (theme.textTheme.bodyLarge?.color ?? Colors.grey),
                      ),
                    ),
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18.0,
                          minHeight: 18.0,
                        ),
                        child: Center(
                          child: Text(
                            '19',
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
                label: 'Чаты',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SafeSvgIcon(
                      assetPath: 'assets/bottom/call.svg',
                      width: 24.0,
                      height: 24.0,
                      color: _currentIndex == 1
                          ? theme.colorScheme.secondary
                          : (theme.textTheme.bodyLarge?.color ?? Colors.grey),
                      fallback: Icon(
                        _currentIndex == 1 ? Icons.phone : Icons.phone_outlined,
                        size: 24.0,
                        color: _currentIndex == 1
                            ? theme.colorScheme.secondary
                            : (theme.textTheme.bodyLarge?.color ?? Colors.grey),
                      ),
                    ),
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18.0,
                          minHeight: 18.0,
                        ),
                        child: Center(
                          child: Text(
                            '19',
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
                label: 'Звонки',
              ),
              BottomNavigationBarItem(
                icon: SafeSvgIcon(
                  assetPath: 'assets/bottom/users.svg',
                  width: 24.0,
                  height: 24.0,
                  color: _currentIndex == 2
                      ? theme.colorScheme.secondary
                      : (theme.textTheme.bodyLarge?.color ?? Colors.grey),
                  fallback: Icon(
                    Icons.people_outline,
                    size: 24.0,
                    color: _currentIndex == 2
                        ? theme.colorScheme.secondary
                        : (theme.textTheme.bodyLarge?.color ?? Colors.grey),
                  ),
                ),
                label: 'Контакты',
              ),
              BottomNavigationBarItem(
                icon: SafeSvgIcon(
                  assetPath: 'assets/bottom/profile.svg',
                  width: 24.0,
                  height: 24.0,
                  color: _currentIndex == 3
                      ? theme.colorScheme.secondary
                      : (theme.textTheme.bodyLarge?.color ?? Colors.grey),
                  fallback: Icon(
                    Icons.person_outline,
                    size: 24.0,
                    color: _currentIndex == 3
                        ? theme.colorScheme.secondary
                        : (theme.textTheme.bodyLarge?.color ?? Colors.grey),
                  ),
                ),
                label: 'Профиль',
              ),
            ],
          ),
        );
      },
    );
  }
}