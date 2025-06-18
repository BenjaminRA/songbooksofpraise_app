import 'package:flutter/material.dart';

class QuickAccessSectionItem {
  final IconData icon;
  final String label;
  final String subLabel;
  final Color color;
  final VoidCallback onPressed;

  QuickAccessSectionItem({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.color,
    required this.onPressed,
  });
}

class QuickAccessSection extends StatefulWidget {
  const QuickAccessSection({super.key});

  @override
  State<QuickAccessSection> createState() => _QuickAccessSectionState();
}

class _QuickAccessSectionState extends State<QuickAccessSection> {
  List<Widget> _quickAccessItems() {
    List<QuickAccessSectionItem> items = [
      QuickAccessSectionItem(
        icon: Icons.list,
        label: 'Browse',
        subLabel: 'Categories',
        color: const Color.fromRGBO(119, 24, 40, 1.0),
        onPressed: () {},
      ),
      QuickAccessSectionItem(
        icon: Icons.favorite,
        label: 'Favorites',
        subLabel: '21 songs',
        color: const Color.fromRGBO(232, 43, 53, 1.0),
        onPressed: () {},
      ),
      QuickAccessSectionItem(
        icon: Icons.access_time_filled,
        label: 'Recent',
        subLabel: 'Last played',
        color: const Color.fromRGBO(47, 105, 243, 1.0),
        onPressed: () {},
      ),
      QuickAccessSectionItem(
        icon: Icons.menu_book,
        label: 'Songbooks',
        subLabel: 'Manage',
        color: const Color.fromRGBO(201, 161, 42, 1.0),
        onPressed: () {},
      ),
    ];

    return items.map((item) {
      return MaterialButton(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        onPressed: item.onPressed,
        child: Container(
          width: 146.0,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: item.color.withAlpha(50),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(item.icon, color: item.color, size: 28.0),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.subLabel,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Quick Access',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 16.0,
            children: _quickAccessItems(),
          ),
        )
      ],
    );
  }
}
