import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbooksTab/pages/SongbookPage.dart';

class SongbooksMenuInstalled extends StatelessWidget {
  final List<Songbook> songbooks;
  final Future<void> Function() onRefresh;

  const SongbooksMenuInstalled({super.key, required this.songbooks, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    AppLocalizations localizations = AppLocalizations.of(context)!;

    Widget buildSongbookItem(Songbook item) {
      return MaterialButton(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        onPressed: () {
          Provider.of<AppBarProvider>(context, listen: false).setTitle(
            AppBarState(
              title: item.title,
              icon: Icons.library_books,
            ),
          );
          songbookTabKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => SongbookPage(songbook: item),
            ),
          );
        },
        // onPressed: item.onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.library_books, color: theme.primaryColor, size: 18.0),
                  const SizedBox(width: 12),
                  Text(item.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        enableDrag: true,
                        context: context,
                        useRootNavigator: true,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                        ),
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.library_books, color: theme.primaryColor, size: 24.0),
                                    const SizedBox(width: 8),
                                    Text(
                                      item.title,
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
                                  child: Divider(
                                    indent: 16.0,
                                    endIndent: 16.0,
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.refresh),
                                  title: Text(localizations.update, style: theme.textTheme.labelLarge),
                                  onTap: () {
                                    // Handle edit action
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete, color: Colors.red),
                                  title: Text(localizations.delete, style: theme.textTheme.labelLarge?.copyWith(color: Colors.red)),
                                  onTap: () {
                                    // Handle delete action
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(Icons.more_vert, color: Colors.grey[700], size: 18.0),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                localizations.songsCount(item.songCount),
                // '${item.songCount} songs • ${item.description}',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    localizations.lastUpdated(item.updatedAt.toLocal().toString().split(' ')[0]),
                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    // Sample data for installed songbooks
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16.6,
        children: songbooks.map((item) => buildSongbookItem(item)).toList(),
      ),
    );
  }
}
