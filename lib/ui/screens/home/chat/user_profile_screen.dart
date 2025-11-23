import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:exchats/ui/shared_widgets/appbar_icon_button.dart';
import 'package:exchats/view_models/home/chats/dialog_viewmodel.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String? userStatus;

  const UserProfileScreen({
    Key? key,
    required this.userId,
    required this.userName,
    this.userStatus,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          onTap: () => Navigator.of(context).pop(),
        ),
        actions: [
          AppBarIconButton(
            icon: Icons.edit,
            iconColor: const Color(0xFF62697B),
            onTap: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 96.0,
                    height: 96.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/profile/user.svg',
                        width: 48.0,
                        height: 48.0,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Name
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Status
                  Text(
                    widget.userStatus ?? 'В сети',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF1677FF),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.phone,
                            label: 'Звонок',
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.videocam,
                            label: 'Видео',
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.notifications_off,
                            label: 'Звук',
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: _buildActionCard(
                            icon: Icons.search,
                            label: 'Поиск',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Profile Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildDetailCard(
                    label: 'Телефон',
                    value: '+7 (909) 844-12-23',
                    valueColor: const Color(0xFF1677FF),
                  ),
                  const SizedBox(height: 8.0),
                  _buildDetailCard(
                    label: 'О себе',
                    value: 'БИО',
                    valueColor: Colors.black87,
                    valueFontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8.0),
                  _buildDetailCard(
                    label: 'Имя пользователя',
                    value: '@Art_26',
                    valueColor: const Color(0xFF1677FF),
                  ),
                  const SizedBox(height: 8.0),
                  _buildDetailCard(
                    label: 'Почта',
                    value: 'qwerty@mail.ru',
                    valueColor: const Color(0xFF1677FF),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
            // Tabs
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                    // Tab Content
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
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({required IconData icon, required String label}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF1677FF),
                  size: 24.0,
                ),
                const SizedBox(height: 4.0),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF1677FF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String label,
    required String value,
    required Color valueColor,
    FontWeight valueFontWeight = FontWeight.normal,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: valueFontWeight,
              color: valueColor,
            ),
          ),
        ],
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
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFF1677FF) : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            width: 50.0,
            height: 2.0,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1677FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(1.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaTab() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(4.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 1.0,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
    );
  }

  Widget _buildFilesTab() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Text(
                    'PDF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Название PDF',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '25 мб, 5 мин назад',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.download,
                  color: Colors.black87,
                ),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLinksTab() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Text(
                    'I',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instagram',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'https://www.instagram.co...sh=sdJ23',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF1677FF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

