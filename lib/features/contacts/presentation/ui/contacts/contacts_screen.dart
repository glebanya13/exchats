import 'package:flutter/material.dart';
import 'package:exchats/core/constants/app_strings.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactItem {
  final String name;
  final Color avatarColor;
  final bool isOnline;
  final DateTime? lastSeen;

  ContactItem({
    required this.name,
    required this.avatarColor,
    required this.isOnline,
    this.lastSeen,
  });
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<ContactItem> _allContacts = [
    ContactItem(name: 'Артём', avatarColor: Colors.pink, isOnline: true),
    ContactItem(
      name: 'Дмитрий',
      avatarColor: Colors.orange,
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
    ),
    ContactItem(
      name: 'Олег',
      avatarColor: Colors.blue,
      isOnline: false,
      lastSeen: DateTime(2024, 9, 10, 20, 42),
    ),
  ];

  List<ContactItem> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredContacts = _allContacts;
    _searchController.addListener(_filterContacts);
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
            .where((contact) => contact.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    final hour = lastSeen.hour.toString().padLeft(2, '0');
    final minute = lastSeen.minute.toString().padLeft(2, '0');
    final time = '$hour:$minute';

    if (difference.inDays == 0) {
      return 'Был(а) в $time';
    } else if (difference.inDays == 1) {
      return 'Был(а) вчера в $time';
    } else if (lastSeen.year == now.year) {
      final months = [
        'января',
        'февраля',
        'марта',
        'апреля',
        'мая',
        'июня',
        'июля',
        'августа',
        'сентября',
        'октября',
        'ноября',
        'декабря',
      ];
      return 'Был(а) ${lastSeen.day} ${months[lastSeen.month - 1]} в $time';
    } else {
      final months = [
        'января',
        'февраля',
        'марта',
        'апреля',
        'мая',
        'июня',
        'июля',
        'августа',
        'сентября',
        'октября',
        'ноября',
        'декабря',
      ];
      return 'Был(а) ${lastSeen.day} ${months[lastSeen.month - 1]} ${lastSeen.year} в $time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 20.0,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Сортировка по времени захода',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredContacts.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: index < _filteredContacts.length - 1 ? 8.0 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 48.0,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  color: contact.avatarColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/profile/user.svg',
                                    width: 28.0,
                                    height: 28.0,
                                    colorFilter: ColorFilter.mode(
                                      contact.avatarColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contact.name,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      contact.isOnline
                                          ? AppStrings.online
                                          : contact.lastSeen != null
                                          ? _formatLastSeen(contact.lastSeen!)
                                          : 'Недавно',
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
