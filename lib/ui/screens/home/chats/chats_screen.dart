import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:exchats/ui/shared_widgets/appbar_icon_button.dart';
import 'package:exchats/view_models/home/chats/chat_viewmodel.dart';
import 'package:exchats/view_models/home/chats/chats_viewmodel.dart';
import 'package:exchats/view_models/home/chats/dialog_list_item_viewmodel.dart';
import 'package:exchats/view_models/home/chats/dialog_viewmodel.dart';
import 'package:exchats/view_models/home/chats/group_viewmodel.dart';
import 'package:exchats/view_models/home/chats/saved_messages_list_item_viewmodel.dart';
import 'package:exchats/view_models/home/chats/saved_messages_viewmodel.dart';

import '../router.dart';
import '../new_chat/new_chat_screen.dart';
import 'strings.dart';
import 'widgets/chat_loading_list_item.dart';
import 'widgets/dialog_list_item.dart';
import 'widgets/saved_messages_list_item.dart';
import 'widgets/swipeable_chat_item.dart';
import 'archive_screen.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isArchiveVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<ChatsViewModel>().loadChats();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleArchive() {
    final chatsViewModel = context.read<ChatsViewModel>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<ChatsViewModel>.value(
          value: chatsViewModel,
          child: const ArchiveScreen(),
        ),
      ),
    );
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
              final searchBarHeight = 56.0;
              final tabsHeight = 48.0;
              final dividerHeight = 1.0;
              final topAreaHeight = searchBarHeight + tabsHeight + dividerHeight;
              
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        color: Color(0xFFF8F9FA),
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const NewChatScreen(),
                                    ),
                                  );
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
                          color: Color(0xFFF8F9FA),
                          height: 48.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            children: [
                              _buildCategoryTab('Все', 23, 0),
                              _buildCategoryTab('Личные', 19, 1),
                              _buildCategoryTab('Сохраненные', 0, 2),
                              _buildCategoryTab('Системные', 0, 3),
                            ],
                          ),
                        ),
                        const Divider(height: 1.0),
                      Expanded(
                        child: Selector<ChatsViewModel, bool>(
          selector: (context, model) => model.chatsLoaded,
          builder: (context, chatsLoaded, child) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 350),
              reverseDuration: Duration(milliseconds: 350),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              child: chatsLoaded ? _buildChatList() : _buildChatListLoader(),
            );
          },
        ),
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
              color: isSelected ? theme.colorScheme.secondary : Colors.transparent,
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
                    ? theme.colorScheme.secondary
                    : Colors.black87,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.secondary
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
    return Builder(
      builder: (context) {
    return Consumer<ChatsViewModel>(
      builder: (context, model, child) {
            final filteredChats = _getFilteredChats(model.chats);
            
            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildArchiveItem();
                }
                final chatIndex = index - 1;
            if (chatIndex < 0 || chatIndex >= filteredChats.length) {
              return const SizedBox.shrink();
            }
            final chatViewModel = filteredChats[chatIndex];

            if (chatViewModel is SavedMessagesViewModel) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<SavedMessagesViewModel>.value(
                    value: chatViewModel,
                  ),
                  ChangeNotifierProxyProvider<SavedMessagesViewModel,
                      SavedMessagesListItemViewModel>(
                    create: (_) => SavedMessagesListItemViewModel(),
                    update: (_, viewModel, listItemViewModel) =>
                        listItemViewModel!..update(viewModel),
                  ),
                ],
                child: SavedMessagesListItem(),
              );
            } else if (chatViewModel is DialogViewModel) {
              return SwipeableChatItem(
                chatId: chatViewModel.chat.id,
                onMute: () {},
                onLock: () {},
                onDelete: () {},
                onArchive: () {},
                child: MultiProvider(
                providers: [
                  ChangeNotifierProvider<ChatViewModel>.value(
                    value: chatViewModel,
                  ),
                  ChangeNotifierProvider<DialogViewModel>.value(
                    value: chatViewModel,
                  ),
                  ChangeNotifierProxyProvider<DialogViewModel,
                      DialogListItemViewModel>(
                    create: (_) => DialogListItemViewModel(),
                    update: (_, viewModel, listItemViewModel) =>
                        listItemViewModel!..update(viewModel),
                  ),
                ],
                child: DialogListItem(),
                ),
              );
            } else if (chatViewModel is GroupViewModel) {
              return SwipeableChatItem(
                chatId: chatViewModel.chat.id,
                onMute: () {},
                onLock: () {},
                onDelete: () {},
                onArchive: () {},
                child: MultiProvider(
                providers: [
                  ChangeNotifierProvider<ChatViewModel>.value(
                    value: chatViewModel,
                  ),
                  ChangeNotifierProvider<GroupViewModel>.value(
                    value: chatViewModel,
                  ),
                  ChangeNotifierProxyProvider<GroupViewModel,
                      DialogListItemViewModel>(
                    create: (_) => DialogListItemViewModel(),
                    update: (_, viewModel, listItemViewModel) =>
                        listItemViewModel!..updateGroupViewModel(viewModel),
                  ),
                ],
                child: DialogListItem(),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
          itemCount: filteredChats.length + 1,
            );
          },
        );
      },
    );
  }

  List<ChatViewModel> _getFilteredChats(List<ChatViewModel> allChats) {
    switch (_selectedTabIndex) {
      case 0: // Все
        return allChats;
      case 1: // Личные
        return allChats.where((chat) => chat is DialogViewModel).toList();
      case 2: // Сохраненные
        return allChats.where((chat) => chat is SavedMessagesViewModel).toList();
      case 3: // Системные
        return [];
      default:
        return allChats;
    }
  }

  Widget _buildChatListLoader() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        for (int i = 0; i < 12; i++) ChatLoadingListItem(),
      ],
    );
  }

  Widget _buildArchiveItem() {
    return InkWell(
      onTap: _toggleArchive,
      child: SizedBox(
        height: 72.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1677FF),
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
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 14.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Архив',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 48.0,
                                  margin: const EdgeInsets.only(
                                    left: 6.0,
                                    bottom: 2.0,
                                  ),
                                  child: Text(
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
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Артём, Елена',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 130, 143, 152),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 48.0,
                                  margin: const EdgeInsets.only(left: 6.0),
                                  child: UnconstrainedBox(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      height: 24.0,
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      constraints: BoxConstraints(
                                        minWidth: 24.0,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        color: Colors.grey[700],
                                      ),
                                      child: Center(
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: -14.0,
                      child: Divider(height: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

