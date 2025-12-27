import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/components/Breadcrumbs.dart';
import 'package:songbooksofpraise_app/models/Category.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/RootPage.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/helpers/onCategoryTabHandler.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/helpers/renderCategories.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/pages/CategoryPage.dart';

class SongbookPage extends StatefulWidget {
  final Songbook songbook;

  const SongbookPage({super.key, required this.songbook});

  @override
  State<SongbookPage> createState() => _SongbookPageState();
}

class _SongbookPageState extends State<SongbookPage> {
  int? loadingCategory;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: ListView(
        children: [
          Breadcrumbs(items: [localizations.songbooks, widget.songbook.title]),
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
              children: widget.songbook.categories
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
