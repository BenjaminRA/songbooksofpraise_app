import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/helpers/renderLastPlayedText.dart';

class RecentlyPlayedSectionItem {
  final int? number;
  final String title;
  final String category;
  final DateTime? lastPlayed;

  RecentlyPlayedSectionItem({
    this.number,
    required this.title,
    required this.category,
    this.lastPlayed,
  });
}

class RecentlyPlayedSection extends StatefulWidget {
  const RecentlyPlayedSection({super.key});

  @override
  State<RecentlyPlayedSection> createState() => _RecentlyPlayedSectionState();
}

class _RecentlyPlayedSectionState extends State<RecentlyPlayedSection> {
  String _renderSongIconText(RecentlyPlayedSectionItem item) {
    return item.number != null ? item.number.toString() : item.title.substring(0, 1).toUpperCase();
  }

  Widget _buildRecentlyPlayedItem(RecentlyPlayedSectionItem item) {
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(50),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                _renderSongIconText(item),
                textAlign: TextAlign.center,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  '${item.category} • ${renderLastPlayedText(item.lastPlayed)}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<RecentlyPlayedSectionItem> recentlyPlayedItems = [
      RecentlyPlayedSectionItem(number: 999, title: 'Amazing Grace', category: 'Hymn', lastPlayed: DateTime.now().subtract(Duration(days: 1))),
      RecentlyPlayedSectionItem(title: 'How Great Thou Art', category: 'Hymn'),
      RecentlyPlayedSectionItem(title: 'Be Thou My Vision', category: 'Hymn', lastPlayed: DateTime.now().subtract(Duration(days: 2))),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently Played',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                // style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  // Handle "See All" action
                },
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 16.0,
            children: recentlyPlayedItems.map((item) => _buildRecentlyPlayedItem(item)).toList(),
          ),
        )
      ],
    );
  }
}
