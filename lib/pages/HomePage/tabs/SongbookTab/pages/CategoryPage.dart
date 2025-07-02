import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/components/Breadcrumbs.dart';
import 'package:songbooksofpraise_app/models/Category.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbookTab/helpers/renderCategories.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbookTab/helpers/renderSongs.dart';

class CategoryPage extends StatelessWidget {
  final List<Category> categoryRoute;

  const CategoryPage({super.key, required this.categoryRoute});

  @override
  Widget build(BuildContext context) {
    final category = categoryRoute.last;
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

    for (int i = 0; i < categoryRoute.length; i++) {
      breadcrumbsItems.add(
        categoryRoute[i].title,
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
                    category.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    category.description ?? genericCategoryDescriptions[Random().nextInt(genericCategoryDescriptions.length)],
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
                        onPressed: () {
                          // Provider.of<AppBarProvider>(context, listen: false).setTitle(
                          //   AppBarState(
                          //     title: Provider.of<AppBarProvider>(context, listen: false).state.title,
                          //     icon: Icons.library_books,
                          //   ),
                          // );
                          // songbookTabKey.currentState?.push(
                          //   MaterialPageRoute(
                          //     builder: (context) => CategoryPage(categoryRoute: [...categoryRoute, item]),
                          //   ),
                          // );
                        },
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
                      onPressed: () {
                        Provider.of<AppBarProvider>(context, listen: false).setTitle(
                          AppBarState(
                            title: Provider.of<AppBarProvider>(context, listen: false).state.title,
                            icon: Icons.library_books,
                          ),
                        );
                        songbookTabKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(categoryRoute: [...categoryRoute, item]),
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
