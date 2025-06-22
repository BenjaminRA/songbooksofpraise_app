import 'package:flutter/material.dart';

class SongbooksMenuItem {
  final String title;
  final String? description;
  final int hymnCount;

  SongbooksMenuItem({required this.title, required this.hymnCount, this.description});
}

class SongbooksMenuInstalled extends StatefulWidget {
  const SongbooksMenuInstalled({super.key});

  @override
  State<SongbooksMenuInstalled> createState() => _SongbooksMenuInstalledState();
}

class _SongbooksMenuInstalledState extends State<SongbooksMenuInstalled> {
  Widget _buildSongbookItem(SongbooksMenuItem item) {
    return MaterialButton(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      onPressed: () {},
      // onPressed: item.onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.library_books, color: Theme.of(context).primaryColor, size: 18.0),
                const SizedBox(width: 12),
                Text(item.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      enableDrag: true,
                      context: context,
                      useRootNavigator: true,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.edit, color: Colors.blue),
                                title: Text('Edit'),
                                onTap: () {
                                  // Handle edit action
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Delete'),
                                onTap: () {
                                  // Handle delete action
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Icon(Icons.more_vert, color: Colors.grey[700], size: 18.0),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${item.hymnCount} hymns${item.description != null ? ' • ${item.description}' : ''}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample data for installed songbooks
    final List<SongbooksMenuItem> installedSongbooks = [
      SongbooksMenuItem(title: 'Himnos y Cánticos del Evangelio', hymnCount: 150, description: 'Popular hymns'),
      SongbooksMenuItem(title: 'Coros', hymnCount: 200, description: 'Classic hymns'),
      SongbooksMenuItem(title: 'Worship traditional hymns', hymnCount: 180, description: 'Modern hymns'),
      SongbooksMenuItem(title: 'Red Book Hymns', hymnCount: 220, description: 'Traditional hymns'),
      SongbooksMenuItem(title: 'Black Book Hymns', hymnCount: 175, description: 'Contemporary hymns'),
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16.6,
        children: installedSongbooks.map((item) => _buildSongbookItem(item)).toList(),
      ),
    );
  }
}
