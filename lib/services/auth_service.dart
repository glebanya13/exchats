import 'dart:math';
import 'package:exchats/locator.dart';
import 'package:exchats/models/user_details.dart';
import 'package:exchats/services/user_service.dart';
import 'package:exchats/services/mock_data.dart';

class AuthService {
  final String _numbers = '1234567890';
  final Random _random = Random();
  
  String? _currentUserId = MockData.currentUserId; // Инициализируем для демо

  String? get currentUserId => _currentUserId;

  bool isAuthenticated() {
    return _currentUserId != null;
  }

  void signInWithPhoneNumber(
    String phoneNumber, {
    required void Function(dynamic) verificationCompleted,
    void Function(dynamic)? verificationFailed,
    required void Function(String, int?) codeSent,
    void Function(String)? codeAutoRetrievalTimeout,
    String? autoRetrievedSmsCodeForTesting,
    int? forceResendingToken,
  }) {
    // Моковая авторизация - сразу отправляем код
    Future.delayed(Duration(seconds: 1), () {
      codeSent('123456', null);
    });
  }

  Future<void> signInWithCredential(dynamic credential) async {
    // Моковая авторизация - просто устанавливаем текущего пользователя
    _currentUserId = MockData.currentUserId;
    
    // Проверяем, новый ли пользователь
    final userService = locator<UserService>();
    final user = await userService.getUserById(id: _currentUserId!);
    
    if (user == null) {
      final username = _generateUsername();
      await userService.addUser(
        id: _currentUserId!,
        details: UserDetails(
          username: username,
          firstName: username,
          lastName: '',
          phoneNumber: '+1234567890',
          online: true,
          chats: [],
        ),
      );
    }
  }

  String _generateUsername() {
    return 'User${String.fromCharCodes(Iterable.generate(8, (_) => _numbers.codeUnitAt(_random.nextInt(_numbers.length))))}';
  }

  Future<void> logout() async {
    _currentUserId = null;
  }
}
