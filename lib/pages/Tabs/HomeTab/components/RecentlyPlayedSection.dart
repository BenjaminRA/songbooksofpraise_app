import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/helpers/navigateToSong.dart';
import 'package:songbooksofpraise_app/helpers/renderLastPlayedText.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/RecentlyPlayedPage.dart';

class RecentlyPlayedSectionItem {
  final Song song;
  final String songbook;

  RecentlyPlayedSectionItem({
    required this.song,
    required this.songbook,
  });
}

class RecentlyPlayedSection extends StatefulWidget {
  const RecentlyPlayedSection({super.key});

  @override
  State<RecentlyPlayedSection> createState() => _RecentlyPlayedSectionState();
}

class _RecentlyPlayedSectionState extends State<RecentlyPlayedSection> {
  List<RecentlyPlayedSectionItem> recentlyPlayedSongs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    fetchRecentlyPlayedSongs();
  }

  void fetchRecentlyPlayedSongs() async {
    setState(() {
      loading = true;
    });

    List<RecentlyPlayedSectionItem> songs = await Song.getRecentlyPlayedSongs(10);

    if (mounted) {
      setState(() {
        recentlyPlayedSongs = songs;
        loading = false;
      });
    }
  }

  String _renderSongIconText(RecentlyPlayedSectionItem item) {
    return item.song.number != null ? item.song.number.toString() : item.song.title.substring(0, 1).toUpperCase();
  }

  Widget _buildRecentlyPlayedItem(RecentlyPlayedSectionItem item) {
    return MaterialButton(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      onPressed: item.song.id > -1
          ? () {
              navigateToSong(context, item.song.id);
            }
          : null,
      // onPressed: item.onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Skeleton.ignore(
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  _renderSongIconText(item),
                  textAlign: TextAlign.center,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.song.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    '${item.songbook} • ${renderLastPlayedText(context, item.song.lastPlayed)}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.recentlyPlayed,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                // style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<AppBarProvider>(context, listen: false).setTitle(
                    AppBarState(
                      title: localizations.recentlyPlayed,
                      icon: Icons.access_time_filled,
                      // backgroundColor: const Color.fromRGBO(47, 105, 243, 1.0),
                      // titleColor: Colors.white,
                      iconColor: const Color.fromRGBO(47, 105, 243, 1.0),
                    ),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RecentlyPlayedPage()),
                  );
                },
                child: Text(
                  localizations.viewAll,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Skeletonizer(
            enabled: loading,
            child: Builder(
              builder: (context) {
                if (loading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 16.0,
                    children: [
                      _buildRecentlyPlayedItem(
                        RecentlyPlayedSectionItem(
                          song: Song(
                              id: -1,
                              title: 'Loading...',
                              songbook_id: -1,
                              created_at: DateTime.now(),
                              updated_at: DateTime.now(),
                              lastPlayed: DateTime.now()),
                          songbook: '...',
                        ),
                      ),
                      _buildRecentlyPlayedItem(
                        RecentlyPlayedSectionItem(
                          song: Song(
                              id: -1,
                              title: 'Loading...',
                              songbook_id: -1,
                              created_at: DateTime.now(),
                              updated_at: DateTime.now(),
                              lastPlayed: DateTime.now()),
                          songbook: '...',
                        ),
                      ),
                      _buildRecentlyPlayedItem(
                        RecentlyPlayedSectionItem(
                          song: Song(
                              id: -1,
                              title: 'Loading...',
                              songbook_id: -1,
                              created_at: DateTime.now(),
                              updated_at: DateTime.now(),
                              lastPlayed: DateTime.now()),
                          songbook: '...',
                        ),
                      ),
                    ],
                  );
                }

                if (recentlyPlayedSongs.isEmpty) {
                  return Card(
                    elevation: 1.0,
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.music_note_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.noRecentlyPlayedSongs,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 16.0,
                  children: recentlyPlayedSongs.map((item) => _buildRecentlyPlayedItem(item)).toList(),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
