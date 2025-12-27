import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/db/DB.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Category.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/pages/CategoryPage.dart';

Future<void> onCategoryTapHandler(BuildContext context, Category item) async {
  AppLocalizations localizations = AppLocalizations.of(context)!;

  if (item.subcategories.isEmpty) {
    try {
      Category? category = await Category.getCategoryByID(item.id, item.songbookID);

      // If exists in local database
      if (category == null) {
        final response = await API.get('songbooks/${item.songbookID}/categories/${item.id == -1 ? 'all' : item.id}');

        category = Category.fromJson(response['category']);
      }

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
          subtitle:
              Provider.of<AppBarProvider>(context, listen: false).state.subtitle ?? Provider.of<AppBarProvider>(context, listen: false).state.title,
          title: item.id == -1 ? localizations.all : item.name,
          icon: Icons.library_books,
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CategoryPage(category: category!),
        ),
      );
    } catch (e) {
      print('Error fetching category details: $e');
    }
  } else {
    Provider.of<AppBarProvider>(context, listen: false).setTitle(
      AppBarState(
        subtitle: Provider.of<AppBarProvider>(context, listen: false).state.title,
        title: item.name,
        icon: Icons.library_books,
      ),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryPage(category: item),
      ),
    );
  }
}
