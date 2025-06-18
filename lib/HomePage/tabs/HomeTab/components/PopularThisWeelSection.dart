import 'package:flutter/material.dart';

class PopularThisWeekSectionItem {
  final int? number;
  final String title;
  final String category;
  final int timesPlayed;

  PopularThisWeekSectionItem({
    this.number,
    required this.title,
    required this.category,
    required this.timesPlayed,
  });
}

class PopularThisWeekSection extends StatefulWidget {
  const PopularThisWeekSection({super.key});

  @override
  State<PopularThisWeekSection> createState() => _PopularThisWeekSectionState();
}

class _PopularThisWeekSectionState extends State<PopularThisWeekSection> {
  String _renderSongIconText(PopularThisWeekSectionItem item) {
    return item.number != null ? item.number.toString() : item.title.substring(0, 1).toUpperCase();
  }

  Widget _buildPopularThisWeekItem(PopularThisWeekSectionItem item) {
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
                color: const Color.fromRGBO(201, 161, 42, 1.0).withAlpha(50),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                _renderSongIconText(item),
                textAlign: TextAlign.center,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 16.0, color: const Color.fromRGBO(201, 161, 42, 1.0)),
              ),
            ),
            const SizedBox(width: 12.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  '${item.category} • ${item.timesPlayed} plays',
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
    List<PopularThisWeekSectionItem> popularThisWeekItems = [
      PopularThisWeekSectionItem(number: 999, title: 'Amazing Grace', category: 'Hymn', timesPlayed: 5),
      PopularThisWeekSectionItem(title: 'How Great Thou Art', category: 'Hymn', timesPlayed: 3),
      PopularThisWeekSectionItem(title: 'Be Thou My Vision', category: 'Hymn', timesPlayed: 4),
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
                'Popular This Week',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
            children: popularThisWeekItems.map((item) => _buildPopularThisWeekItem(item)).toList(),
          ),
        )
      ],
    );
  }
}
