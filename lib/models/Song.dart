import 'package:songbooksofpraise_app/db/DB.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/components/RecentlyPlayedSection.dart';

class Song {
  int id;
  String title;
  String lyrics;
  String? music_sheet;
  String? music;
  String? music_only;
  String? youtube_url;
  int? number;
  String? voices_all;
  String? voices_soprano;
  String? voices_contralto;
  String? voices_tenor;
  String? voices_bass;
  int transpose;
  int scroll_speed;
  int songbook_id;
  DateTime created_at;
  DateTime updated_at;

  Song({
    required this.id,
    this.number,
    required this.title,
    this.lyrics = '',
    this.music_sheet,
    this.music,
    this.music_only,
    this.youtube_url,
    this.voices_all,
    this.voices_soprano,
    this.voices_contralto,
    this.voices_tenor,
    this.voices_bass,
    this.transpose = 0,
    this.scroll_speed = 0,
    required this.songbook_id,
    required this.created_at,
    required this.updated_at,
  });

  static Future<List<Song>> getSongsByCategoryID(int categoryID) async {
    final rows = await DB.rawQuery('''
      SELECT songs.* FROM songs
      JOIN song_categories ON songs.id = song_categories.song_id
      WHERE song_categories.category_id = ?;
    ''', arguments: [categoryID]);

    List<Song> songs = [];

    for (dynamic row in rows) {
      songs.add(Song(
        id: row['id'],
        title: row['title'],
        lyrics: row['lyrics'] ?? '',
        music_sheet: row['music_sheet'],
        music: row['music'],
        music_only: row['music_only'],
        youtube_url: row['youtube_url'],
        number: row['number'],
        voices_all: row['voices_all'],
        voices_soprano: row['voices_soprano'],
        voices_contralto: row['voices_contralto'],
        voices_tenor: row['voices_tenor'],
        voices_bass: row['voices_bass'],
        transpose: row['transpose'] ?? 0,
        scroll_speed: row['scroll_speed'] ?? 0,
        songbook_id: row['songbook_id'],
        created_at: DateTime.parse(row['created_at']),
        updated_at: DateTime.parse(row['updated_at']),
      ));
    }

    return songs;
  }

  static Future<Song?> getSongByID(int songID) async {
    final rows = await DB.rawQuery('SELECT * FROM songs WHERE id = ?;', arguments: [songID]);

    if (rows.isEmpty) {
      return null;
    }

    final row = rows.first;

    return Song(
      id: row['id'],
      title: row['title'],
      lyrics: row['lyrics'] ?? '',
      music_sheet: row['music_sheet'],
      music: row['music'],
      music_only: row['music_only'],
      youtube_url: row['youtube_url'],
      number: row['number'],
      voices_all: row['voices_all'],
      voices_soprano: row['voices_soprano'],
      voices_contralto: row['voices_contralto'],
      voices_tenor: row['voices_tenor'],
      voices_bass: row['voices_bass'],
      transpose: row['transpose'] ?? 0,
      scroll_speed: row['scroll_speed'] ?? 0,
      songbook_id: row['songbook_id'],
      created_at: DateTime.parse(row['created_at']),
      updated_at: DateTime.parse(row['updated_at']),
    );
  }

  static Song fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      lyrics: json['lyrics'] ?? '',
      music_sheet: json['music_sheet'],
      music: json['music'],
      music_only: json['music_only'],
      youtube_url: json['youtube_url'],
      number: json['number'],
      voices_all: json['voices_all'],
      voices_soprano: json['voices_soprano'],
      voices_contralto: json['voices_contralto'],
      voices_tenor: json['voices_tenor'],
      voices_bass: json['voices_bass'],
      transpose: json['transpose'] ?? 0,
      scroll_speed: json['scroll_speed'] ?? 0,
      songbook_id: json['songbook_id'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
    );
  }

  static Future<List<RecentlyPlayedSectionItem>> GetRecentlyPlayedSongs(int limit, [int offset = 0]) async {
    final rows = await DB.rawQuery('''
      SELECT 
        songs.*,
        recently_played_songs.played_at,
        songbooks.title AS songbook_title 
      FROM songs
      JOIN songbooks ON songs.songbook_id = songbooks.id
      LEFT JOIN recently_played_songs ON songs.id = recently_played_songs.song_id
      ORDER BY recently_played_songs.played_at DESC
      LIMIT ? OFFSET ?;
    ''', arguments: [limit, offset]);

    List<RecentlyPlayedSectionItem> songs = [];

    for (dynamic row in rows) {
      songs.add(RecentlyPlayedSectionItem(
        number: row['number'],
        title: row['title'],
        songbook: row['songbook_title'],
        lastPlayed: row['played_at'] != null ? DateTime.parse(row['played_at']) : null,
      ));
    }

    return songs;
  }
}
