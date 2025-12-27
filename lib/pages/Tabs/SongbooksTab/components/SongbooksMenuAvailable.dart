import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/db/DB.dart';
import 'package:songbooksofpraise_app/helpers/render_date.dart';
import 'package:songbooksofpraise_app/models/Category.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/RootPage.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/SongbookTab.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/pages/SongbookPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

class SongbooksMenuAvailable extends StatefulWidget {
  final List<Songbook> songbooks;
  final SongbookCallbacks callbacks;

  const SongbooksMenuAvailable({super.key, required this.songbooks, required this.callbacks});

  @override
  State<SongbooksMenuAvailable> createState() => _SongbooksMenuAvailableState();
}

class _SongbooksMenuAvailableState extends State<SongbooksMenuAvailable> {
  // Songbook being loaded
  int? loadingSongbook;

  void onSongbookTapHandler(Songbook item) async {
    setState(() => loadingSongbook = item.id);

    try {
      final categories = await API.get('songbooks/${item.id}/categories');

      item.categories = categories['categories'].map((categoryData) => Category.fromJson(categoryData)).toList().cast<Category>();

      item.categories.insert(
        0,
        Category(
          id: -1,
          name: 'All',
          songs: [],
          subcategories: [],
          songbookID: item.id,
          songCount: item.songCount,
        ),
      );

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
    } catch (e) {
      print('Error fetching categories: $e');
    }

    if (mounted) {
      setState(() => loadingSongbook = null);
    }
  }

  void onDownloadTapHandler(Songbook item) async {
    widget.callbacks.downloadSongbook(item);
  }

  void onUpdateTapHandler(Songbook item) async {
    await widget.callbacks.updateSongbook(item);
  }

  void onDeleteTapHandler(Songbook item) async {
    await widget.callbacks.deleteSongbook(item);
  }

  Widget _buildSongbookItem(Songbook item, AppLocalizations localizations) {
    bool isLoading = loadingSongbook == item.id;

    return MaterialButton(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      disabledColor: Colors.grey[200],
      disabledElevation: 1.0,
      onPressed: loadingSongbook == null ? () => onSongbookTapHandler(item) : null,
      // onPressed: item.onPressed,
      child: Stack(
        children: [
          if (item.isInstalled)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                    visualDensity: VisualDensity.compact,
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.white,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.white,
                  ),
                  onPressed: loadingSongbook == null ? () => onDeleteTapHandler(item) : null,
                  child: Icon(Icons.delete),
                  // child: Text(localizations.delete),
                ),
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.0,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      (item.isInstalled ? Icons.save : Icons.cloud_download),
                      color: Theme.of(context).textTheme.labelSmall?.color,
                      size: 18.0,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      (item.isInstalled ? localizations.installedSingular : localizations.availableSingular).toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const Spacer(),
                    if (isLoading)
                      Center(
                        child: SpinKitThreeInOut(
                          color: Theme.of(context).primaryColor,
                          size: 18.0,
                        ),
                      ),
                  ],
                ),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  localizations.songsCount(item.songCount),
                  // '${item.songCount} hymns${item.description != null ? ' • ${item.description}' : ''}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Builder(
                  builder: (context) {
                    List<Widget> children = [
                      Text(
                        localizations.lastUpdated(renderDate(item.updatedAt)),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ];

                    if (item.isInstalled) {
                      if (item.updateAvailable) {
                        children.add(
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                              visualDensity: VisualDensity.compact,
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              disabledBackgroundColor: Colors.grey[300],
                              disabledForegroundColor: Colors.white,
                            ),
                            onPressed: loadingSongbook == null ? () => onUpdateTapHandler(item) : null,
                            child: item.isDownloading ? SpinKitThreeBounce(color: Colors.white, size: 16.0) : Text(localizations.update),
                          ),
                        );
                      }
                    } else {
                      children.add(
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.white,
                          ),
                          onPressed: loadingSongbook == null ? () => onDownloadTapHandler(item) : null,
                          child: item.isDownloading ? SpinKitThreeBounce(color: Colors.white, size: 16.0) : Text(localizations.download),
                        ),
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: children,
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16.6,
        children: widget.songbooks.map((item) => _buildSongbookItem(item, localizations)).toList(),
      ),
    );
  }
}
