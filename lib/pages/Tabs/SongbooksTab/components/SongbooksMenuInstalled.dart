import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/RootPage.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/SongbookTab.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/pages/SongbookPage.dart';

class SongbooksMenuInstalled extends StatefulWidget {
  final List<Songbook> songbooks;
  final SongbookCallbacks callbacks;

  const SongbooksMenuInstalled({super.key, required this.songbooks, required this.callbacks});

  @override
  State<SongbooksMenuInstalled> createState() => _SongbooksMenuInstalledState();
}

class _SongbooksMenuInstalledState extends State<SongbooksMenuInstalled> {
  void onUpdateTapHandler(Songbook item) async {
    await widget.callbacks.updateSongbook(item);
  }

  void onDeleteTapHandler(Songbook item) async {
    await widget.callbacks.deleteSongbook(item);
  }

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
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.library_books, color: theme.primaryColor, size: 18.0),
                      if (item.updateAvailable)
                        if (item.isDownloading)
                          Positioned(
                            right: -10.0,
                            top: -10.0,
                            child: Container(
                              width: 19.0,
                              height: 19.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                child: SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: 8.0,
                                ),
                              ),
                            ),
                          )
                        else
                          Positioned(
                            right: -5.0,
                            top: -5.0,
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                            ),
                          ),
                    ],
                  ),
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
                                if (item.updateAvailable)
                                  ListTile(
                                    leading: item.isDownloading
                                        ? SizedBox(
                                            width: 25.0,
                                            height: 25.0,
                                            child: Center(
                                              child: SpinKitThreeBounce(
                                                color: Colors.blue,
                                                size: 16.0,
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.refresh,
                                            color: Colors.blue,
                                          ),
                                    title:
                                        Text(item.isDownloading ? localizations.updating : localizations.update, style: theme.textTheme.labelLarge),
                                    onTap: item.isDownloading
                                        ? null
                                        : () {
                                            Navigator.pop(context);
                                            onUpdateTapHandler(item);
                                          },
                                  ),
                                ListTile(
                                  leading: Icon(Icons.delete, color: Colors.red),
                                  title: Text(localizations.delete, style: theme.textTheme.labelLarge),
                                  onTap: () {
                                    Navigator.pop(context);
                                    onDeleteTapHandler(item);
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
              const SizedBox(height: 6),
              Text(
                localizations.songsCount(item.songCount),
                // '${item.songCount} songs • ${item.description}',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
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
        children: widget.songbooks.map((item) => buildSongbookItem(item)).toList(),
      ),
    );
  }
}
