import 'package:flutter/foundation.dart';
import 'package:exchats/models/user_details.dart';
import 'package:exchats/services/auth_service.dart';
import 'package:exchats/services/mock_data.dart';
import 'package:exchats/services/user_service.dart';
import 'package:exchats/locator.dart';

class ContactsViewModel extends ChangeNotifier {
  final UserService _userService = locator<UserService>();
  final AuthService _authService = locator<AuthService>();

  List<UserDetails> _contacts = [];
  bool _isLoading = true;
  String _searchQuery = '';

  List<UserDetails> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  List<UserDetails> get filteredContacts {
    if (_searchQuery.isEmpty) {
      return _contacts;
    }
    final query = _searchQuery.toLowerCase();
    return _contacts.where((contact) {
      final fullName = '${contact.firstName} ${contact.lastName}'.toLowerCase();
      final phone = contact.phoneNumber.toLowerCase();
      return fullName.contains(query) || phone.contains(query);
    }).toList();
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUserId = _authService.currentUserId;
      if (currentUserId == null) {
        _contacts = [];
        return;
      }

      // Получаем всех пользователей кроме текущего
      final allUsers = MockData.users.values.toList();
      _contacts = allUsers
          .where((user) => user.phoneNumber != MockData.currentUser.phoneNumber)
          .toList();

      // Сортируем по имени
      _contacts.sort((a, b) {
        final nameA = '${a.firstName} ${a.lastName}'.toLowerCase();
        final nameB = '${b.firstName} ${b.lastName}'.toLowerCase();
        return nameA.compareTo(nameB);
      });
    } catch (e) {
      debugPrint('Error loading contacts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

