import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exchats/util/slide_left_with_fade_route.dart';
import 'package:exchats/view_models/home/chats/chats_viewmodel.dart';
import 'package:exchats/view_models/home/contacts/contacts_viewmodel.dart';

import 'call/call_screen.dart';
import 'chats/chats_screen.dart';
import 'contacts/contacts_screen.dart';
import 'new_chat/new_chat_screen.dart';
import 'profile/folders_screen.dart';
import 'profile/my_profile_screen.dart';
import 'profile/notifications_screen.dart';
import 'profile/privacy_screen.dart';

abstract class HomeRoutes {
  static const String Chats = 'chats';
  static const String Contacts = 'contacts';
  static const String NewChat = 'new_chat';
  static const String Call = 'call';
  static const String MyProfile = 'my_profile';
  static const String Notifications = 'notifications';
  static const String Folders = 'folders';
  static const String Privacy = 'privacy';
}

class HomeRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeRoutes.Chats:
        return SlideWithFadeRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => ChatsViewModel(),
            child: ChatsScreen(),
          ),
        );
      case HomeRoutes.Contacts:
        return SlideWithFadeRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => ContactsViewModel(),
            child: const ContactsScreen(),
          ),
        );
      case HomeRoutes.NewChat:
        return SlideWithFadeRoute(
          builder: (context) => const NewChatScreen(),
        );
      case HomeRoutes.Call:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => CallScreen(
            userId: args?['userId'] as String?,
            userName: args?['userName'] as String?,
            isIncoming: args?['isIncoming'] as bool? ?? false,
            isVideoCall: args?['isVideoCall'] as bool? ?? false,
          ),
        );
      case HomeRoutes.MyProfile:
        return MaterialPageRoute(
          builder: (context) => const MyProfileScreen(),
        );
      case HomeRoutes.Notifications:
        return MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
        );
      case HomeRoutes.Folders:
        return MaterialPageRoute(
          builder: (context) => const FoldersScreen(),
        );
      case HomeRoutes.Privacy:
        return MaterialPageRoute(
          builder: (context) => const PrivacyScreen(),
        );
      default:
        return SlideWithFadeRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Telegram'),
              ),
              body: Center(
                child: Text(
                  'No route defined for ${settings.name}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            );
          },
        );
    }
  }
}
