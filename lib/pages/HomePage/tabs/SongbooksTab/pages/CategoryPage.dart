import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/components/Breadcrumbs.dart';
import 'package:songbooksofpraise_app/models/Category.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbooksTab/helpers/renderCategories.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbooksTab/helpers/renderSongs.dart';
import 'package:songbooksofpraise_app/pages/SongPage/SongPage.dart';

class CategoryPage extends StatefulWidget {
  final List<Category> categoryRoute;

  const CategoryPage({super.key, required this.categoryRoute});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int? loadingCategory;
  int? loadingSong;

  void onCategoryTapHandler(Category item) async {
    if (item.subcategories.isEmpty) {
      setState(() => loadingCategory = item.id);

      try {
        final response = await API.get('songbooks/${item.songbookID}/categories/${item.id}');

        print(response['category']);

        final category = Category.fromJson(response['category']);

        category.songs.sort((a, b) {
          final aValue = a.number != null ? '${a.number} - ${a.title}' : a.title;
          final bValue = b.number != null ? '${b.number} - ${b.title}' : b.title;

          if (a.number != null && b.number != null) {
            return a.number! - b.number!;
          }

          return aValue.compareTo(bValue);
        });

        Provider.of<AppBarProvider>(context, listen: false).setTitle(
          AppBarState(
            title: Provider.of<AppBarProvider>(context, listen: false).state.title,
            icon: Icons.library_books,
          ),
        );
        songbookTabKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => CategoryPage(categoryRoute: [...widget.categoryRoute, category]),
          ),
        );
      } catch (e) {
        print('Error fetching category details: $e');
      } finally {
        if (mounted) {
          setState(() => loadingCategory = null);
        }
      }
    } else {
      Provider.of<AppBarProvider>(context, listen: false).setTitle(
        AppBarState(
          title: Provider.of<AppBarProvider>(context, listen: false).state.title,
          icon: Icons.library_books,
        ),
      );
      songbookTabKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => CategoryPage(categoryRoute: [...widget.categoryRoute, item]),
        ),
      );
    }
  }

  void onSongTapHandler(Song item) async {
    setState(() => loadingSong = item.id);
    try {
      final response = await API.get('songs/${item.id}');

      final song = Song.fromJson(response['song']);

      Provider.of<AppBarProvider>(context, listen: false).setTitle(
        AppBarState(
          title: item.title,
          subtitle: item.number?.toString(),
          icon: Icons.music_note,
        ),
      );
      songbookTabKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => SongPage(
            song: song,
          ),
        ),
      );
    } catch (e) {
    } finally {
      if (mounted) {
        setState(() => loadingSong = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.categoryRoute.last;
    const List<String> genericCategoryDescriptions = [
      "Explore the hymns in this category.",
      "A collection of songs for inspiration and worship.",
      "Discover hymns organized by this theme.",
      "Songs gathered for special moments and occasions.",
      "Enjoy a variety of hymns selected for this category.",
      "A selection of meaningful hymns.",
      "Find uplifting songs in this section.",
      "Hymns curated for your spiritual journey.",
      "Browse songs that fit this category.",
      "A group of hymns to enrich your worship experience.",
      "Explore the collection of hymns in this category.",
      "Songs to inspire and uplift.",
      "A special selection of hymns for this topic.",
      "Discover new favorites in this category.",
      "Meaningful songs for every occasion.",
    ];

    List<String> breadcrumbsItems = ['Songbooks', Provider.of<AppBarProvider>(context, listen: false).state.title];

    for (int i = 0; i < widget.categoryRoute.length; i++) {
      breadcrumbsItems.add(
        widget.categoryRoute[i].name,
      );
    }

    if (category.subcategories.isEmpty) {
      return Scaffold(
        body: ListView(
          children: [
            Breadcrumbs(items: breadcrumbsItems),
            Container(
              padding: EdgeInsets.only(top: 24.0, bottom: 28.0),
              child: Column(
                children: [
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    genericCategoryDescriptions[Random().nextInt(genericCategoryDescriptions.length)],
                    textAlign: TextAlign.center,
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
                children: category.songs
                    .map(
                      (item) => renderSongs(
                        context,
                        item,
                        onPressed: () => onSongTapHandler(item),
                        loadingSong: loadingSong,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView(
        children: [
          Breadcrumbs(items: breadcrumbsItems),
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
                  textAlign: TextAlign.center,
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
              children: category.subcategories
                  .map(
                    (item) => renderCategories(
                      context,
                      item,
                      onPressed: () => onCategoryTapHandler(item),
                      loadingCategory: loadingCategory,
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
