import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:exchats/ui/shared_widgets/appbar_icon_button.dart';

import 'strings.dart';
import 'widgets/call_link_dialog.dart';

class ContactItem {
  final String name;
  final Color avatarColor;

  ContactItem({
    required this.name,
    required this.avatarColor,
  });
}

class NewCallScreen extends StatefulWidget {
  const NewCallScreen({Key? key}) : super(key: key);

  @override
  _NewCallScreenState createState() => _NewCallScreenState();
}

class _NewCallScreenState extends State<NewCallScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<ContactItem> _allContacts = [
    ContactItem(name: 'Артём', avatarColor: Colors.pink),
    ContactItem(name: 'Дмитрий', avatarColor: Colors.orange),
    ContactItem(name: 'Елена', avatarColor: Colors.purple),
    ContactItem(name: 'Иван', avatarColor: Colors.blue),
    ContactItem(name: 'Олег', avatarColor: Colors.teal),
    ContactItem(name: 'Мария', avatarColor: Colors.indigo),
  ];
  List<ContactItem> _filteredContacts = [];
  List<String> _selectedContacts = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: AppBarIconButton(
          icon: Icons.arrow_back,
          iconColor: Colors.black,
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text(
          CallsStrings.kNewCall,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: CallsStrings.kSearch,
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
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
            // Create Call Link Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  onTap: () {
                    _showCallLinkDialog(context);
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Transform.rotate(
                          angle: 0.785398, // 45 degrees in radians
                          child: Icon(
                            Icons.link,
                            color: const Color(0xFF1677FF),
                            size: 24.0,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          CallsStrings.kCreateCallLink,
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
            ),
            const SizedBox(height: 16.0),
            // Contacts List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredContacts.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  final isSelected = _selectedContacts.contains(contact.name);
                  return _buildContactItem(contact, isSelected);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedContacts.isNotEmpty
          ? Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: const Color(0xFF1677FF),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // TODO: Start call with selected contacts
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildContactItem(ContactItem contact, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedContacts.remove(contact.name);
          } else {
            _selectedContacts.add(contact.name);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            // Avatar
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
            // Name
            Expanded(
              child: Text(
                contact.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFF1677FF),
                size: 24.0,
              ),
          ],
        ),
      ),
    );
  }

  void _showCallLinkDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CallLinkDialog(),
    );
  }
}
