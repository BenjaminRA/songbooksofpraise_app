import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/components/Breadcrumbs.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Category.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/RootPage.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/helpers/onCategoryTabHandler.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/helpers/renderCategories.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/helpers/renderSongs.dart';
import 'package:songbooksofpraise_app/pages/SongPage/SongPage.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int? loadingCategory;
  int? loadingSong;

  void onSongTapHandler(Song item) async {
    setState(() => loadingSong = item.id);
    try {
      Song? song = await Song.getSongByID(item.id);

      // If exists in local database
      if (song == null) {
        final response = await API.get('songs/${item.id}');

        song = Song.fromJson(response['song']);
      }

      Provider.of<AppBarProvider>(context, listen: false).setTitle(
        AppBarState(
          title: item.title,
          subtitle: item.number?.toString(),
          icon: Icons.music_note,
          backgroundColor: Theme.of(context).primaryColor,
          titleColor: Theme.of(context).scaffoldBackgroundColor,
          subtitleColor: Theme.of(context).scaffoldBackgroundColor,
          iconColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
      songbookTabKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => SongPage(
            song: song!,
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
    final breadcrumbs = Provider.of<AppBarProvider>(context).breadcrumbTitles;
    AppLocalizations localizations = AppLocalizations.of(context)!;

    final List<String> genericCategoryDescriptions = [
      localizations.genericCategoryDescription1,
      localizations.genericCategoryDescription2,
      localizations.genericCategoryDescription3,
      localizations.genericCategoryDescription4,
      localizations.genericCategoryDescription5,
      localizations.genericCategoryDescription6,
      localizations.genericCategoryDescription7,
      localizations.genericCategoryDescription8,
      localizations.genericCategoryDescription9,
      localizations.genericCategoryDescription10,
      localizations.genericCategoryDescription11,
      localizations.genericCategoryDescription12,
      localizations.genericCategoryDescription13,
      localizations.genericCategoryDescription14,
      localizations.genericCategoryDescription15,
    ];

    List<String> breadcrumbsItems = breadcrumbs;

    if (widget.category.subcategories.isEmpty) {
      return Scaffold(
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Breadcrumbs(items: breadcrumbsItems),
            Container(
              padding: EdgeInsets.only(top: 24.0, bottom: 28.0),
              child: Column(
                children: [
                  Text(
                    widget.category.id == -1 ? localizations.all : widget.category.name,
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
                children: widget.category.songs
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
        physics: BouncingScrollPhysics(),
        children: [
          Breadcrumbs(items: breadcrumbsItems),
          Container(
            padding: EdgeInsets.only(top: 24.0, bottom: 28.0),
            child: Column(
              children: [
                Text(
                  localizations.browseCategories,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  localizations.exploreCategoriesDescription,
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
              children: widget.category.subcategories
                  .map(
                    (item) => renderCategories(
                      context,
                      item,
                      onPressed: () async {
                        setState(() => loadingCategory = item.id);
                        await onCategoryTapHandler(context, item);
                        setState(() => loadingCategory = null);
                      },
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
