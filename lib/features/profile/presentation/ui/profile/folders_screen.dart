import 'package:flutter/material.dart';

class FoldersScreen extends StatefulWidget {
  const FoldersScreen({Key? key}) : super(key: key);

  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  final List<String> _folders = [
    'Все чаты',
    'Личные',
    'Сохраненные',
    'Системные',
    'Финансы',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _folders.removeAt(oldIndex);
            _folders.insert(newIndex, item);
          });
        },
        children: [
          ..._folders.asMap().entries.map((entry) {
            final index = entry.key;
            final folder = entry.value;
            return _buildFolderItem(
              key: ValueKey(folder),
              title: folder,
              hasMenu: index != 0,
              folderIndex: index,
            );
          }).toList(),
          _buildCreateFolderButton(context),
        ],
      ),
    );
  }

  Widget _buildFolderItem({
    required Key key,
    required String title,
    required bool hasMenu,
    required int folderIndex,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          GestureDetector(
            onLongPress: () {},
            child: Container(
              width: 24.0,
              height: 24.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 16.0,
                    height: 2.0,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    width: 16.0,
                    height: 2.0,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
          ),
          if (hasMenu)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_horiz,
                color: Colors.grey[400],
                size: 24.0,
              ),
              onSelected: (value) {
                if (value == 'configure') {
                } else if (value == 'delete') {
                  setState(() {
                    _folders.removeAt(folderIndex);
                  });
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'configure',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.grey[700], size: 20.0),
                      const SizedBox(width: 12.0),
                      Text(
                        'Настроить папку',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20.0),
                      const SizedBox(width: 12.0),
                      Text(
                        'Удалить',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCreateFolderButton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: ValueKey('create_folder'),
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              'Создать новую папку',
              style: TextStyle(
                fontSize: 16.0,
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
