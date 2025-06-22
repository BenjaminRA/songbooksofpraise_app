import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/CategoryPage/CategoryPage.dart';
import 'package:songbooksofpraise_app/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';

class CategoriesSectionItem {
  final IconData? icon;
  final Color? color;
  final String title;
  final int hymnsCount;
  final int subcategoriesCount;

  CategoriesSectionItem({
    this.icon,
    this.color,
    required this.title,
    required this.hymnsCount,
    required this.subcategoriesCount,
  });
}

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  Widget _buildCategoriesSectionItem(CategoriesSectionItem item) {
    return MaterialButton(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      onPressed: () {
        Provider.of<AppBarProvider>(context, listen: false).setTitle(
          AppBarState(
            title: 'Categories',
            icon: Icons.library_books,
          ),
        );
        songbookTabKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => CategoryPage(category: item),
          ),
        );
      },
      // onPressed: item.onPressed,
      child: Hero(
        tag: 'category_page_${item.title.replaceAll(" ", "_")}',
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (item.icon != null)
                Container(
                  decoration: BoxDecoration(
                    color: item.color ?? Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(item.icon, color: Colors.white, size: 28.0),
                ),
              if (item.icon != null) const SizedBox(width: 12.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    '${item.hymnsCount} hymns · ${item.subcategoriesCount} subcategories',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<CategoriesSectionItem> categories = [
      CategoriesSectionItem(
        icon: Icons.library_books,
        color: Color(0xFF8C1C24),
        title: 'All',
        hymnsCount: 85,
        subcategoriesCount: 6,
      ),
      CategoriesSectionItem(
        icon: Icons.volunteer_activism,
        color: Color.fromARGB(255, 56, 59, 60),
        title: 'Worship & Praise',
        hymnsCount: 85,
        subcategoriesCount: 6,
      ),
      CategoriesSectionItem(
        icon: Icons.church,
        color: Color(0xFFB89B1C),
        title: 'Salvation & Grace',
        hymnsCount: 72,
        subcategoriesCount: 5,
      ),
      CategoriesSectionItem(
        icon: Icons.event,
        color: Color(0xFF1C8C3A),
        title: 'Seasonal & Special',
        hymnsCount: 96,
        subcategoriesCount: 8,
      ),
      CategoriesSectionItem(
        icon: Icons.favorite,
        color: Color(0xFF1C4CB8),
        title: 'Christian Life',
        hymnsCount: 68,
        subcategoriesCount: 7,
      ),
    ];

    return Column(
      children: [
        Hero(
          tag: 'category_page_header',
          child: Container(
            padding: EdgeInsets.only(top: 24.0, bottom: 28.0),
            child: Column(
              children: [
                Text(
                  'Browse Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Explore hymns organized by themes and occasions',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: 16.0,
            children: categories.map((item) => _buildCategoriesSectionItem(item)).toList(),
          ),
        )
      ],
    );
  }
}
