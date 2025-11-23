import 'dart:async';
import 'package:exchats/models/user_details.dart';
import 'package:exchats/services/mock_data.dart';
import 'package:exchats/services/auth_service.dart';
import 'package:exchats/locator.dart';

class UserService {
  static const String _kCollectionName = 'users';

  Stream<UserDetails?> onUserChanged({required String id}) {
    final controller = StreamController<UserDetails?>.broadcast();
    
    // Эмулируем поток данных
    Timer.periodic(Duration(seconds: 5), (timer) {
      final user = _getUserById(id);
      controller.add(user);
    });
    
    // Отправляем начальное значение
    Future.microtask(() {
      final user = _getUserById(id);
      controller.add(user);
    });
    
    return controller.stream;
  }

  Future<UserDetails?> getUserById({required String id}) async {
    return _getUserById(id);
  }

  UserDetails? _getUserById(String id) {
    return MockData.users[id];
  }

  Future<void> addUser({
    required String id,
    required UserDetails details,
  }) async {
    MockData.users[id] = details;
  }

  Future<List<String>> getChats() async {
    final authService = locator<AuthService>();
    final userId = authService.currentUserId;
    
    if (userId == null) return [];
    
    final user = _getUserById(userId);
    return user?.chats ?? [];
  }

  Future<void> setOnlineStatus(bool online) async {
    final authService = locator<AuthService>();
    final userId = authService.currentUserId;
    
    if (userId == null) return;
    
    final user = _getUserById(userId);
    if (user != null) {
      MockData.users[userId] = UserDetails(
        username: user.username,
        firstName: user.firstName,
        lastName: user.lastName,
        phoneNumber: user.phoneNumber,
        online: online,
        chats: user.chats,
      );
    }
  }
}
