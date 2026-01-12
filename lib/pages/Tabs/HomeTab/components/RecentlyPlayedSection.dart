import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:songbooksofpraise_app/helpers/navigateToSong.dart';
import 'package:songbooksofpraise_app/helpers/render_last_played_text.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Song.dart';

class RecentlyPlayedSectionItem {
  final int? id;
  final int? number;
  final String title;
  final String songbook;
  final DateTime? lastPlayed;

  RecentlyPlayedSectionItem({
    this.id,
    this.number,
    required this.title,
    required this.songbook,
    this.lastPlayed,
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

    List<RecentlyPlayedSectionItem> songs = await Song.GetRecentlyPlayedSongs(3);

    if (mounted) {
      setState(() {
        recentlyPlayedSongs = songs;
        loading = false;
      });
    }
  }

  String _renderSongIconText(RecentlyPlayedSectionItem item) {
    return item.number != null ? item.number.toString() : item.title.substring(0, 1).toUpperCase();
  }

  Widget _buildRecentlyPlayedItem(RecentlyPlayedSectionItem item) {
    return MaterialButton(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      onPressed: item.id != null
          ? () {
              navigateToSong(context, item.id!);
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
                  Text(item.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    '${item.songbook} • ${renderLastPlayedText(context, item.lastPlayed)}',
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
                  // Handle "See All" action
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
                        _buildRecentlyPlayedItem(RecentlyPlayedSectionItem(title: 'Loading...', songbook: '...', lastPlayed: DateTime.now())),
                        _buildRecentlyPlayedItem(RecentlyPlayedSectionItem(title: 'Loading...', songbook: '...', lastPlayed: DateTime.now())),
                        _buildRecentlyPlayedItem(RecentlyPlayedSectionItem(title: 'Loading...', songbook: '...', lastPlayed: DateTime.now())),
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
              )),
        )
      ],
    );
  }
}
