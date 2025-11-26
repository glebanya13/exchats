import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:exchats/ui/shared_widgets/appbar_icon_button.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: _isSearching ? _buildSearchField() : buildTitle(context),
      ),
      leading: AppBarIconButton(
        icon: Icons.arrow_back,
        iconColor: Colors.black,
        onTap: () {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
              _searchController.clear();

            });
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      actions: <Widget>[
        if (!_isSearching)
        AppBarIconButton(
            onTap: () {
              setState(() {
                _isSearching = true;
              });
            },
          icon: Icons.search,
          iconSize: 24,
          iconColor: Theme.of(context).textTheme.displayLarge!.color!,
        ),
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('Contacts'),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: TextStyle(
        color: Theme.of(context).textTheme.displayLarge!.color,
        fontSize: 18.0,
      ),
      decoration: InputDecoration(
        hintText: 'Search contacts',
        hintStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
        ),
        border: InputBorder.none,
      ),
      onChanged: (value) {

      },
    );
  }
}
