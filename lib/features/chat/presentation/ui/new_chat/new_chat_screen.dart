import 'package:flutter/material.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:exchats/core/di/locator.dart';
import 'package:exchats/features/chat/presentation/store/chat_store.dart';
import 'package:exchats/features/auth/presentation/store/auth_store.dart';
import 'package:exchats/features/chat/domain/entity/chat_entity.dart';
import 'package:exchats/features/user/domain/entity/user_entity.dart';
import 'package:exchats/features/user/domain/repository/user_repository.dart';
import 'package:exchats/core/assets/gen/assets.gen.dart';
import 'package:go_router/go_router.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({Key? key}) : super(key: key);

  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedUserIds = {};
  final ChatStore _chatStore = locator<ChatStore>();
  final AuthStore _authStore = locator<AuthStore>();
  bool _isCreating = false;
  bool _isLoadingContacts = false;

  List<UserEntity> _allContacts = [];
  List<UserEntity> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterContacts);
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoadingContacts = true;
    });

    try {
      // Получаем текущего пользователя
      UserEntity? currentUser = _authStore.currentUser;
      if (currentUser == null) {
        await _authStore.checkAuthStatus();
        currentUser = _authStore.currentUser;
      }

      if (currentUser == null) {
        setState(() {
          _isLoadingContacts = false;
        });
        return;
      }

      // Загружаем чаты, чтобы получить список участников
      final currentUserId = _authStore.currentUserId;
      if (currentUserId != null) {
        await _chatStore.loadChats(currentUserId);
      }

      // Собираем всех уникальных пользователей из участников комнат
      final Set<String> seenUserIds = {currentUser.id};
      final List<UserEntity> contacts = [];

      for (final chat in _chatStore.chats) {
        // Используем participantUserIds из уже загруженных чатов
        for (final userId in chat.participantUserIds) {
          if (!seenUserIds.contains(userId) && userId != currentUser.id) {
            seenUserIds.add(userId);
            // Получаем данные пользователя
            try {
              final user = await locator<UserRepository>().getUserById(userId);
              if (user != null) {
                contacts.add(user);
              }
            } catch (e) {
              // Игнорируем ошибки получения пользователя
            }
          }
        }
      }

      setState(() {
        _allContacts = contacts;
        _filteredContacts = contacts;
        _isLoadingContacts = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingContacts = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _allContacts;
      } else {
        _filteredContacts = _allContacts
            .where((contact) =>
                contact.name.toLowerCase().contains(query) ||
                contact.phone.contains(query) ||
                (contact.username.isNotEmpty &&
                    contact.username.toLowerCase().contains(query)))
            .toList();
      }
    });
  }

  void _toggleContact(String userId) {
    setState(() {
      if (_selectedUserIds.contains(userId)) {
        _selectedUserIds.remove(userId);
      } else {
        _selectedUserIds.add(userId);
      }
    });
  }

  Color _getAvatarColor(String userId) {
    // Генерируем цвет на основе ID пользователя
    final hash = userId.hashCode;
    final colors = [
      Colors.purple,
      Colors.pink,
      Colors.green,
      Colors.orange,
      Colors.blue,
      Colors.teal,
      Colors.indigo,
      Colors.red,
    ];
    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Новый чат',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[400], size: 20.0),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Поиск',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16.0,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoadingContacts
                ? Center(child: CircularProgressIndicator())
                : _filteredContacts.isEmpty
                    ? Center(
                        child: Text(
                          'Нет доступных контактов',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: _filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = _filteredContacts[index];
                          final displayName = contact.name.isNotEmpty
                              ? contact.name
                              : contact.phone;
                          final avatarColor = _getAvatarColor(contact.id);
                          final isSelected = _selectedUserIds.contains(contact.id);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.grey[200] : Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: () => _toggleContact(contact.id),
                              borderRadius: BorderRadius.circular(8.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20.0,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.grey[400]!,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(4.0),
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.transparent,
                                      ),
                                      child: isSelected
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 14.0,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12.0),
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: avatarColor.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Assets.profile.user.svg(
                                          width: 20.0,
                                          height: 20.0,
                                          colorFilter: ColorFilter.mode(
                                            avatarColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Text(
                                        displayName,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: _selectedUserIds.isNotEmpty
          ? Container(
              width: 48.0,
              height: 48.0,
              child: FloatingActionButton(
                onPressed: _isCreating ? null : _handleCreateChat,
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _isCreating
                    ? SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20.0,
                      ),
              ),
            )
          : null,
    );
  }

  Future<void> _handleCreateChat() async {
    if (_selectedUserIds.isEmpty) return;

    setState(() {
      _isCreating = true;
    });

    try {
      // Проверяем и загружаем текущего пользователя
      UserEntity? currentUser = _authStore.currentUser;
      if (currentUser == null) {
        await _authStore.checkAuthStatus();
        currentUser = _authStore.currentUser;
      }

      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      if (_selectedUserIds.length == 1) {
        // Создаем личный чат (private room)
        final otherUserIdStr = _selectedUserIds.first;
        final otherUserId = int.tryParse(otherUserIdStr);
        if (otherUserId == null) {
          throw Exception('Неверный ID пользователя: $otherUserIdStr');
        }

        final chat = ChatEntity(
          id: '0',
          name: null,
          owner: currentUser,
          type: 'private',
          lastMessage: null,
          participantUserIds: [currentUser.id, otherUserIdStr],
          insertedAt: DateTime.now(),
          updatedAt: DateTime.now(),
          encryptionEnabled: false,
          inviteToken: null,
          unreadCount: 0,
        );

        final createdChat = await _chatStore.createChat(chat);

        // Переходим на экран чата
        if (mounted) {
          // Обновляем список чатов
          final currentUserId = _authStore.currentUserId;
          if (currentUserId != null) {
            await _chatStore.loadChats(currentUserId);
          }

          // Переходим на экран чата
          context.go('/chat/${createdChat.id}');
        }
      } else {
        // Несколько контактов - показываем экран создания группы
        final selectedUsers = _allContacts
            .where((user) => _selectedUserIds.contains(user.id))
            .toList();
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateGroupScreen(
                selectedUsers: selectedUsers,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка создания чата: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }
}

class CreateGroupScreen extends StatefulWidget {
  final List<UserEntity> selectedUsers;

  const CreateGroupScreen({Key? key, required this.selectedUsers})
      : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final ChatStore _chatStore = locator<ChatStore>();
  final AuthStore _authStore = locator<AuthStore>();
  bool _isCreating = false;

  Color _getAvatarColor(String userId) {
    // Генерируем цвет на основе ID пользователя
    final hash = userId.hashCode;
    final colors = [
      Colors.purple,
      Colors.pink,
      Colors.green,
      Colors.orange,
      Colors.blue,
      Colors.teal,
      Colors.indigo,
      Colors.red,
    ];
    return colors[hash.abs() % colors.length];
  }

  @override
  void initState() {
    super.initState();
    // Не заполняем поле по умолчанию - пользователь должен ввести название сам
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Новая группа',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Название команды',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F1F3),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _groupNameController,
                      style: TextStyle(fontSize: 16.0, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Введите название группы',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.0),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${widget.selectedUsers.length} участника',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: widget.selectedUsers.map((user) {
                  final displayName = user.name.isNotEmpty ? user.name : user.phone;
                  final avatarColor = _getAvatarColor(user.id);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: avatarColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Assets.profile.user.svg(
                              width: 20.0,
                              height: 20.0,
                              colorFilter: ColorFilter.mode(
                                avatarColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 48.0,
        height: 48.0,
        child: FloatingActionButton(
          onPressed: _isCreating ? null : _createGroup,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: _isCreating
              ? SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(Icons.arrow_forward, color: Colors.white, size: 20.0),
        ),
      ),
    );
  }

  Future<void> _createGroup() async {
    if (_groupNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Введите название группы')),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      // Проверяем и загружаем текущего пользователя, если его нет
      UserEntity? currentUser = _authStore.currentUser;
      if (currentUser == null) {
        await _authStore.checkAuthStatus();
        currentUser = _authStore.currentUser;
      }
      
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      // Получаем user IDs из выбранных пользователей
      final participantUserIds = [
        currentUser.id,
        ...widget.selectedUsers.map((user) => user.id),
      ];

      // Создаем ChatEntity для группы
      // id будет установлен сервером после создания
      final chat = ChatEntity(
        id: '0', // временное значение, будет заменено сервером
        name: _groupNameController.text.trim(),
        owner: currentUser,
        type: 'group',
        lastMessage: null,
        participantUserIds: participantUserIds,
        insertedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        encryptionEnabled: false,
        inviteToken: null,
        unreadCount: 0,
      );

      final createdChat = await _chatStore.createChat(chat);

      // Переходим на экран чата
      if (mounted) {
        // Обновляем список чатов
        final currentUserId = _authStore.currentUserId;
        if (currentUserId != null) {
          await _chatStore.loadChats(currentUserId);
        }
        
        // Переходим на экран чата
        context.go('/chat/${createdChat.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка создания группы: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }
}
