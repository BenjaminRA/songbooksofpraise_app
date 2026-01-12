import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/models/Category.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';

enum SearchResultType { song, category, songbook }

class SearchResult {
  final SearchResultType type;
  final dynamic data;
  final String? songbookTitle;

  SearchResult({
    required this.type,
    required this.data,
    this.songbookTitle,
  });

  String get title {
    switch (type) {
      case SearchResultType.song:
        return (data as Song).title;
      case SearchResultType.category:
        return (data as Category).name;
      case SearchResultType.songbook:
        return (data as Songbook).title;
    }
  }

  String? get subtitle {
    switch (type) {
      case SearchResultType.song:
        final song = data as Song;
        return song.number != null ? '#${song.number}' : null;
      case SearchResultType.category:
        final category = data as Category;
        return '${category.songCount} songs';
      case SearchResultType.songbook:
        final songbook = data as Songbook;
        return '${songbook.songCount} songs';
    }
  }

  int get id {
    switch (type) {
      case SearchResultType.song:
        return (data as Song).id;
      case SearchResultType.category:
        return (data as Category).id;
      case SearchResultType.songbook:
        return (data as Songbook).id;
    }
  }
}
