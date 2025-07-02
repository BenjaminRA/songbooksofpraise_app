import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/components/Breadcrumbs.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbookTab/helpers/renderCategories.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbookTab/pages/CategoryPage.dart';

class SongbookPage extends StatefulWidget {
  final Songbook songbook;

  const SongbookPage({super.key, required this.songbook});

  @override
  State<SongbookPage> createState() => _SongbookPageState();
}

class _SongbookPageState extends State<SongbookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Breadcrumbs(items: ['Songbooks', widget.songbook.title]),
          Container(
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              spacing: 16.0,
              children: widget.songbook.categories
                  .map(
                    (item) => renderCategories(
                      context,
                      item,
                      onPressed: () {
                        Provider.of<AppBarProvider>(context, listen: false).setTitle(
                          AppBarState(
                            title: Provider.of<AppBarProvider>(context, listen: false).state.title,
                            icon: Icons.library_books,
                          ),
                        );
                        songbookTabKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(categoryRoute: [item]),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          // ActiveSongbookSection(songbook: widget.songbook),
        ],
      ),
    );
  }
}
