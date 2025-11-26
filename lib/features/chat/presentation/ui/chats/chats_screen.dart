import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:exchats/ui/shared_widgets/appbar_icon_button.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/di/locator.dart';
import '../../store/chat_store.dart';
import '../../../../../features/auth/presentation/store/auth_store.dart';
import '../../../domain/entity/chat_entity.dart';
import 'package:mobx/mobx.dart';
import '../../../../../ui/screens/home/new_chat/new_chat_screen.dart';
import 'strings.dart';
import 'widgets/chat_loading_list_item.dart';
import 'widgets/chat_list_item.dart';
import 'archive_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatStore _chatStore;
  late final AuthStore _authStore;

  @override
  void initState() {
    super.initState();
    _chatStore = locator<ChatStore>();
    _authStore = locator<AuthStore>();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = _authStore.currentUserId ?? 'user1';
      _chatStore.loadChats(userId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleArchive() {
    context.push('/archive');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Container(
        color: const Color(0xFFF8F9FA),
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        color: const Color(0xFFF8F9FA),
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Поиск',
                                    hintStyle: TextStyle(
                                      color: theme.textTheme.bodyLarge?.color?.withOpacity(0.5),
                                      fontSize: 16.0,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: theme.textTheme.bodyLarge?.color?.withOpacity(0.5),
                                      size: 20.0,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  ),
                                  style: TextStyle(
                                    color: theme.textTheme.displayLarge!.color,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            GestureDetector(
                              onTap: () {
                                context.push('/new_chat');
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                child: SvgPicture.asset(
                                  'assets/bottom/chat-button.svg',
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: const Color(0xFFF8F9FA),
                        height: 48.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          children: [
                            Observer(
                              builder: (_) {
                                final allCount = _chatStore.chats.length;
                                final dialogCount = _chatStore.chats.where((c) => c.type == 'dialog').length;
                                final savedCount = _chatStore.chats.where((c) => c.type == 'saved_messages').length;
                                return Row(
                                  children: [
                                    _buildCategoryTab('Все', allCount, 0),
                                    _buildCategoryTab('Личные', dialogCount, 1),
                                    _buildCategoryTab('Сохраненные', savedCount, 2),
                                    _buildCategoryTab('Системные', 0, 3),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _buildChatList(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, int count, int index) {
    final theme = Theme.of(context);
    final isSelected = _selectedTabIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF1677FF) : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF1677FF)
                    : Colors.black87,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1677FF)
                      : theme.textTheme.bodyLarge?.color?.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return Observer(
      builder: (_) {
        if (_chatStore.isLoading && !_chatStore.chatsLoaded) {
          return ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              _buildArchiveItem(),
              for (int i = 0; i < 10; i++) ChatLoadingListItem(),
            ],
          );
        }

        if (_chatStore.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Ошибка: ${_chatStore.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final filteredChats = _getFilteredChats(_chatStore.chats);

        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: filteredChats.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildArchiveItem();
            }
            final chat = filteredChats[index - 1];
            return ChatListItem(chat: chat);
          },
        );
      },
    );
  }

  List<ChatEntity> _getFilteredChats(ObservableList<ChatEntity> allChats) {
    final chatsList = allChats.toList();
    switch (_selectedTabIndex) {
      case 0:
        return chatsList;
      case 1:
        return chatsList.where((chat) => chat.type == 'dialog').toList();
      case 2:
        return chatsList.where((chat) => chat.type == 'saved_messages').toList();
      case 3:
        return <ChatEntity>[];
      default:
        return chatsList;
    }
  }

  Widget _buildArchiveItem() {
    return InkWell(
      onTap: _toggleArchive,
      child: Container(
        height: 72.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56.0,
              height: 56.0,
              decoration: const BoxDecoration(
                color: Color(0xFF1677FF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/bottom/archive.svg',
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Архив',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        width: 48.0,
                        margin: const EdgeInsets.only(left: 6.0),
                        child: const Text(
                          '01.09',
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 130, 143, 152),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Артём, Елена',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 130, 143, 152),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 24.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                          color: Colors.grey[700],
                        ),
                        child: const Center(
                          child: Text(
                            '2',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
