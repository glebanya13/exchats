import 'package:flutter/material.dart';
import 'package:exchats/core/constants/app_strings.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:exchats/core/widgets/appbar_icon_button.dart';
import 'package:exchats/core/di/locator.dart';
import 'package:exchats/features/user/domain/usecase/user_usecase.dart';
import 'package:exchats/features/user/domain/entity/user_entity.dart';
import 'package:exchats/core/util/last_seen_formatter.dart';
import 'package:exchats/core/util/user_formatter.dart';
import 'package:exchats/core/assets/gen/assets.gen.dart';

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
  UserEntity? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userUseCase = locator<UserUseCase>();
      final user = await userUseCase.getUserById(widget.userId);
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          onTap: () => context.pop(),
        ),
        actions: [
          AppBarIconButton(
            icon: Icons.edit,
            iconColor: AppColors.iconGray,
            onTap: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
              child: Column(
                children: [
                  Container(
                    width: 96.0,
                    height: 96.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Assets.profile.user.svg(
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
                  Text(
                    _user != null
                        ? UserFormatter.resolveDisplayName(_user!)
                        : widget.userName,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _user != null
                        ? (LastSeenFormatter.isOnline(_user!.lastSeenAt)
                            ? AppStrings.online
                            : LastSeenFormatter.format(_user!.lastSeenAt))
                        : (widget.userStatus ?? AppStrings.online),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: _user != null && LastSeenFormatter.isOnline(_user!.lastSeenAt)
                          ? AppColors.primary
                          : Colors.grey[600]!,
                    ),
                  ),
                  const SizedBox(height: 24.0),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  if (_user != null) ...[
                    if (_user!.phone.isNotEmpty)
                      _buildDetailCard(
                        label: 'Телефон',
                        value: _user!.phone,
                        valueColor: AppColors.primary,
                      ),
                    if (_user!.phone.isNotEmpty) const SizedBox(height: 8.0),
                    if (_user!.username != null && _user!.username!.isNotEmpty)
                      _buildDetailCard(
                        label: 'Имя пользователя',
                        value: '@${_user!.username}',
                        valueColor: AppColors.primary,
                      ),
                    if (_user!.username.isNotEmpty)
                      const SizedBox(height: 8.0),
                  ] else if (_isLoading) ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ] else ...[
                    _buildDetailCard(
                      label: 'Телефон',
                      value: 'Не загружено',
                      valueColor: Colors.grey[600]!,
                    ),
                  ],
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
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
                          horizontal: 16.0, vertical: 16.0),
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
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24.0,
                ),
                const SizedBox(height: 4.0),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                    color: AppColors.primary,
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
              color: isSelected ? AppColors.primary : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            width: 50.0,
            height: 2.0,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
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
                      'https://example.com',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: AppColors.primary,
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
