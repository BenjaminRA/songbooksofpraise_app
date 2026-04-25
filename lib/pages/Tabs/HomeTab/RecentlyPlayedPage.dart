import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/components/SongListBuilder.dart';
import 'package:songbooksofpraise_app/helpers/navigateToSong.dart';
import 'package:songbooksofpraise_app/helpers/renderLastPlayedText.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/components/RecentlyPlayedSection.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RecentlyPlayedPage extends StatefulWidget {
  const RecentlyPlayedPage({super.key});

  @override
  State<RecentlyPlayedPage> createState() => _RecentlyPlayedPageState();
}

class _RecentlyPlayedPageState extends State<RecentlyPlayedPage> {
  List<RecentlyPlayedSectionItem> _songs = [];
  bool _loading = true;
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    setState(() => _loading = true);

    final songs = await Song.getRecentlyPlayedSongsByDateRange(
      _selectedRange?.start,
      _selectedRange?.end,
    );

    if (!mounted) return;
    setState(() {
      _songs = songs;
      _loading = false;
    });
  }

  String _dayLabel(DateTime? dt, AppLocalizations localizations) {
    if (dt == null) return localizations.neverPlayed;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return localizations.today;
    if (diff == 1) return localizations.yesterday;
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  List<SongListBuilderItem> _buildItems(AppLocalizations localizations) {
    return _songs.map((recentlyPlayedItem) {
      final Song song = recentlyPlayedItem.song;

      final item = SongListBuilderItem(
        title: song.title,
        subtitle: '${recentlyPlayedItem.songbook} • ${renderLastPlayedText(context, song.lastPlayed)}',
        song: song,
      );
      return item;
    }).toList();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      initialDateRange: _selectedRange,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color.fromRGBO(47, 105, 243, 1.0),
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedRange = picked);
      _fetchSongs();
    }
  }

  void _clearFilter() {
    setState(() => _selectedRange = null);
    _fetchSongs();
  }

  Widget _buildDateFilterSliver(AppLocalizations localizations) {
    final String fromLabel = _selectedRange != null
        ? '${_selectedRange!.start.year}-${_selectedRange!.start.month.toString().padLeft(2, '0')}-${_selectedRange!.start.day.toString().padLeft(2, '0')}'
        : localizations.allTime;
    final String toLabel = _selectedRange != null
        ? '${_selectedRange!.end.year}-${_selectedRange!.end.month.toString().padLeft(2, '0')}-${_selectedRange!.end.day.toString().padLeft(2, '0')}'
        : localizations.allTime;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: Card(
          elevation: 1.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDateRange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.from,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fromLabel,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 12.0),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDateRange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.to,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          toLabel,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_selectedRange != null) ...[
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: _clearFilter,
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      child: const Icon(Icons.close, size: 16.0, color: Colors.grey),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (_loading) {
      return Scaffold(
        body: Center(
          child: SpinKitThreeBounce(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    final items = _buildItems(localizations);

    return SongListBuilder(
      items: items,
      groupBy: (item) => _dayLabel(item.song.lastPlayed, localizations),
      sortBy: (p0, p1) => p1.song.lastPlayed!.compareTo(p0.song.lastPlayed!), // Sort by last played date (newest first)
      slivers: [_buildDateFilterSliver(localizations)],
      enableSideBar: false,
      forceGroupHeaders: true,
      onTap: (item) async {
        final song = item.song;
        if (song.id > -1) {
          await navigateToSong(context, song.id);
        }
        await _fetchSongs();
      },
      emptyStateWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            localizations.noRecentlyPlayedSongs,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
      onToggleFavorite: (item, isFavorite) {
        _fetchSongs();
      },
    );
  }
}
