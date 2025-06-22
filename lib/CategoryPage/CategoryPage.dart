import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SongbookTab/components/ActiveSongbookSection.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SongbookTab/components/CategoriesSection.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/SongPage/SongPage.dart';
import 'package:songbooksofpraise_app/components/SlideInFromRightPageBuilder.dart';

class CategoryPage extends StatefulWidget {
  final CategoriesSectionItem category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
        icon: Icons.volunteer_activism,
        color: Color(0xFF8C1C24),
        title: 'Just Praise',
        hymnsCount: 10,
        subcategoriesCount: 2,
      ),
      CategoriesSectionItem(
        icon: Icons.church,
        color: Color(0xFFB89B1C),
        title: 'Just Worship',
        hymnsCount: 55,
        subcategoriesCount: 4,
      ),
    ];

    return Scaffold(
      body: ListView(
        children: [
          Hero(tag: 'active_songbook', child: ActiveSongbookSection()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                horizontal: BorderSide(color: Color.fromRGBO(254, 247, 218, 1.0), width: 2.0),
              ),
              // borderRadius: BorderRadius.circular(8.0),
            ),
            child: Hero(
              tag: 'category_page_${widget.category.title.replaceAll(" ", "_")}',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.category.icon != null)
                      Container(
                        decoration: BoxDecoration(
                          color: widget.category.color ?? Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(widget.category.icon, color: Colors.white, size: 28.0),
                      ),
                    if (widget.category.icon != null) const SizedBox(width: 12.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.category.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.category.hymnsCount} hymns · ${widget.category.subcategoriesCount} subcategories',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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
          ),
        ],
      ),
    );
  }
}
