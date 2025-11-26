import 'package:go_router/go_router.dart';
import '../../locator.dart';
import '../store/auth_store.dart';
import '../../ui/screens/auth/auth_screen.dart';
import '../../ui/screens/auth/login/login_screen.dart';
import '../../ui/screens/auth/verification/verification_screen.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/home/chats/chats_screen.dart';
import '../../ui/screens/home/chats/archive_screen.dart';
import '../../ui/screens/home/contacts/contacts_screen.dart';
import '../../ui/screens/home/new_chat/new_chat_screen.dart';
import '../../ui/screens/home/call/call_screen.dart';
import '../../ui/screens/home/profile/my_profile_screen.dart';
import '../../ui/screens/home/profile/notifications_screen.dart';
import '../../ui/screens/home/profile/folders_screen.dart';
import '../../ui/screens/home/profile/devices_screen.dart';
import '../../ui/screens/home/profile/business_account_screen.dart';
import '../../ui/screens/home/profile/privacy_screen.dart';
import '../../ui/screens/home/chat/dialog/dialog_screen.dart';
import '../../ui/screens/home/chat/user_profile_screen.dart';
import '../../ui/screens/home/chat/group_profile_screen.dart';
import '../../ui/screens/home/call/active_call_screen.dart';
import '../../ui/screens/home/calls/new_call_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/auth',
    redirect: (context, state) {
      final authStore = locator<AuthStore>();
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      if (!authStore.isAuthenticated && !isAuthRoute) {
        return '/auth';
      }
      
      if (authStore.isAuthenticated && isAuthRoute) {
        return '/';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'verification',
            name: 'verification',
            builder: (context, state) {
              final phoneNumber = state.uri.queryParameters['phoneNumber'] ?? '';
              return VerificationScreen(phoneNumber: phoneNumber);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            path: 'chats',
            name: 'chats',
            builder: (context, state) => ChatsScreen(),
          ),
          GoRoute(
            path: 'chat/:chatId',
            name: 'chat',
            builder: (context, state) {
              final chatId = state.pathParameters['chatId'] ?? '';
              return DialogScreen(chatId: chatId);
            },
          ),
          GoRoute(
            path: 'archive',
            name: 'archive',
            builder: (context, state) => const ArchiveScreen(),
          ),
          GoRoute(
            path: 'contacts',
            name: 'contacts',
            builder: (context, state) => const ContactsScreen(),
          ),
          GoRoute(
            path: 'new_chat',
            name: 'new_chat',
            builder: (context, state) => const NewChatScreen(),
          ),
          GoRoute(
            path: 'call',
            name: 'call',
            builder: (context, state) {
              final userId = state.uri.queryParameters['userId'];
              final userName = state.uri.queryParameters['userName'];
              final isIncoming = state.uri.queryParameters['isIncoming'] == 'true';
              final isVideoCall = state.uri.queryParameters['isVideoCall'] == 'true';
              return CallScreen(
                userId: userId,
                userName: userName,
                isIncoming: isIncoming,
                isVideoCall: isVideoCall,
              );
            },
          ),
          GoRoute(
            path: 'my_profile',
            name: 'my_profile',
            builder: (context, state) => const MyProfileScreen(),
          ),
          GoRoute(
            path: 'notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: 'folders',
            name: 'folders',
            builder: (context, state) => const FoldersScreen(),
          ),
          GoRoute(
            path: 'devices',
            name: 'devices',
            builder: (context, state) => const DevicesScreen(),
          ),
          GoRoute(
            path: 'business_account',
            name: 'business_account',
            builder: (context, state) => const BusinessAccountScreen(),
          ),
          GoRoute(
            path: 'privacy',
            name: 'privacy',
            builder: (context, state) => const PrivacyScreen(),
          ),
          GoRoute(
            path: 'user_profile',
            name: 'user_profile',
            builder: (context, state) {
              final userId = state.uri.queryParameters['userId'] ?? '';
              final userName = state.uri.queryParameters['userName'] ?? '';
              final userStatus = state.uri.queryParameters['userStatus'] ?? 'offline';
              return UserProfileScreen(
                userId: userId,
                userName: userName,
                userStatus: userStatus,
              );
            },
          ),
          GoRoute(
            path: 'group_profile',
            name: 'group_profile',
            builder: (context, state) {
              final groupId = state.uri.queryParameters['groupId'] ?? '';
              final groupName = state.uri.queryParameters['groupName'] ?? 'Группа';
              return GroupProfileScreen(
                groupId: groupId,
                groupName: groupName,
              );
            },
          ),
          GoRoute(
            path: 'active_call',
            name: 'active_call',
            builder: (context, state) {
              final userId = state.uri.queryParameters['userId'] ?? '';
              final userName = state.uri.queryParameters['userName'] ?? '';
              final isVideoCall = state.uri.queryParameters['isVideoCall'] == 'true';
              return ActiveCallScreen(
                userId: userId,
                userName: userName,
                isVideoCall: isVideoCall,
              );
            },
          ),
          GoRoute(
            path: 'new_call',
            name: 'new_call',
            builder: (context, state) => const NewCallScreen(),
          ),
        ],
      ),
    ],
  );
}

