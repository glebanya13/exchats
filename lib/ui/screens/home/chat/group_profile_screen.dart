import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:exchats/ui/shared_widgets/appbar_icon_button.dart';
import 'package:exchats/locator.dart';
import 'package:exchats/presentation/store/user_store.dart';
import 'package:exchats/presentation/store/auth_store.dart';
import 'package:exchats/domain/entity/user_entity.dart';

class GroupProfileScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupProfileScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  State<GroupProfileScreen> createState() => _GroupProfileScreenState();
}

class _GroupProfileScreenState extends State<GroupProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  final UserStore _userStore = locator<UserStore>();
  final AuthStore _authStore = locator<AuthStore>();
  List<UserEntity> _participants = [];
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _loadParticipants();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadParticipants() async {


    setState(() {
      _participants = [];
    });
  }

  void _showParticipantMenu(BuildContext context, UserEntity user, Offset tapPosition) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromSize(
        tapPosition & Size(0, 0),
        overlay.size,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.lock_outline, color: Colors.grey[700], size: 20.0),
              const SizedBox(width: 12.0),
              Text(
                'Изменить разрешения',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
          onTap: () {

          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 14.0),
              ),
              const SizedBox(width: 12.0),
              Text(
                'Удалить из группы',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          onTap: () {

          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: AppBarIconButton(
          icon: Icons.arrow_back,
          iconColor: Colors.black87,
          onTap: () => context.pop(),
        ),
        actions: [
          AppBarIconButton(
            icon: Icons.edit,
            iconColor: Colors.black87,
            onTap: () {},
          ),
          PopupMenuButton<String>(
            icon: Transform.rotate(
              angle: 1.5708, 
              child: Icon(Icons.more_vert, color: Colors.black87),
            ),
            onSelected: (value) {
              if (value == 'search') {

              } else if (value == 'leave') {

              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[700], size: 20.0),
                    const SizedBox(width: 12.0),
                    Text(
                      'Поиск',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'leave',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red, size: 20.0),
                    const SizedBox(width: 12.0),
                    Text(
                      'Выйти из группы',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.groupName,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            Icon(Icons.people, size: 16.0, color: Colors.grey[600]),
                            const SizedBox(width: 4.0),
                            Text(
                              '${_participants.length} участника',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
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

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4.0,
                    offset: Offset(0, 2.0),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Уведомления',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        _notificationsEnabled ? 'Включены' : 'Выключены',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: 0.85,
                    child: CupertinoSwitch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      activeColor: const Color(0xFF1677FF),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4.0,
                        offset: Offset(0, 2.0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add,
                        size: 20.0,
                        color: const Color(0xFF1677FF),
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        'Добавить участников',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1677FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4.0,
                    offset: Offset(0, 2.0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _participants.length; i++)
                    GestureDetector(
                      onLongPressStart: (details) {
                        _showParticipantMenu(context, _participants[i], details.globalPosition);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          border: i < _participants.length - 1
                              ? Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[200]!,
                                    width: 1.0,
                                  ),
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/profile/user.svg',
                                  width: 24.0,
                                  height: 24.0,
                                  colorFilter: ColorFilter.mode(
                                    Colors.grey[700]!,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${_participants[i].firstName} ${_participants[i].lastName}'.trim(),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      if (i == 0)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Администратор',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF1677FF),
                                            ),
                                          ),
                                        )
                                      else if (i == _participants.length - 1)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Владелец',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF1677FF),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    _participants[i].online
                                        ? 'В сети'
                                        : 'Был(а) 5 минут назад',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTab('Медиа', 0),
                          const SizedBox(width: 24.0),
                          _buildTab('Файлы', 1),
                          const SizedBox(width: 24.0),
                          _buildTab('Ссылки', 2),
                        ],
                      ),
                    ),

                    IndexedStack(
                      index: _selectedTabIndex,
                      children: [
                        _buildMediaTab(),
                        _buildFilesTab(),
                        _buildLinksTab(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
          _tabController.animateTo(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? const Color(0xFF1677FF)
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? const Color(0xFF1677FF)
                : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaTab() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilesTab() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 0,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.insert_drive_file, color: Colors.grey[600]),
            title: Text('File ${index + 1}.pdf'),
            subtitle: Text('2.5 MB'),
          );
        },
      ),
    );
  }

  Widget _buildLinksTab() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 0,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: Text(
                  'I',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            title: Text(
              'https://example.com',
              style: TextStyle(
                color: const Color(0xFF1677FF),
                fontSize: 14.0,
              ),
            ),
          );
        },
      ),
    );
  }
}

