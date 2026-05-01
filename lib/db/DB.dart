import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:songbooksofpraise_app/helpers/textNormalization.dart';

class DB {
  static String? _dbPath;
  static final Lock _lock = Lock();

  static Future<String> _getPath() async {
    if (_dbPath == null) {
      String databasesPath = (await getDatabasesPath());
      _dbPath = "$databasesPath/songbooks_of_praise.db";
    }

    return _dbPath!;
  }

  static Future<Null> init() async {
    // Create file if doesn't exists
    File dbFile = File(await _getPath());
    if (!await dbFile.exists()) {
      await dbFile.create(recursive: true);
    }

    // // debug reset db
    // else {
    //   await dbFile.delete();
    // }

    // Initialize the database
    Database db = await openDatabase(await _getPath());

    final batch = db.batch();

    batch.execute('''
      CREATE TABLE IF NOT EXISTS songbooks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        parent_category_id INTEGER,
        songbook_id INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (parent_category_id) REFERENCES categories(id) ON DELETE SET NULL,
        FOREIGN KEY (songbook_id) REFERENCES songbooks(id) ON DELETE CASCADE
      );
    ''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        lyrics TEXT,
        music_sheet TEXT,
        music TEXT,
        music_only TEXT,
        youtube_url TEXT,
        description TEXT,
        number INTEGER,
        voices_all TEXT,
        voices_soprano TEXT,
        voices_contralto TEXT,
        voices_tenor TEXT,
        voices_bass TEXT,
        transpose INTEGER DEFAULT 0,
        scroll_speed REAL DEFAULT 1.0,
        songbook_id INTEGER NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (songbook_id) REFERENCES songbooks(id) ON DELETE CASCADE
      );
    ''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS song_categories (
        song_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        PRIMARY KEY (song_id, category_id),
        FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
      );
    ''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS favorite_songs (
        song_id INTEGER NOT NULL,
        PRIMARY KEY (song_id)
      );
    ''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS favorite_songbooks (
        songbook_id INTEGER NOT NULL,
        PRIMARY KEY (songbook_id)
      );
    ''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS recently_played_songs (
        song_id INTEGER NOT NULL,
        played_at DATETIME DEFAULT (datetime('now', 'localtime')),
        FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE
      );
    ''');

    await batch.commit();

    // Add column favorite to table songs
    try {
      await db.execute('''
        ALTER TABLE songs
        ADD COLUMN favorite BOOLEAN DEFAULT FALSE
      ''');
    } catch (e) {
      print('Table songs already has the column favorite');
    }

    // Add column font_size to table songs
    try {
      await db.execute('''
        ALTER TABLE songs
        ADD COLUMN font_size REAL DEFAULT NULL
      ''');
    } catch (e) {
      print('Table songs already has the column font_size');
    }

    // Add normalized columns for accent-insensitive search
    try {
      await db.execute('''
        ALTER TABLE songs
        ADD COLUMN title_normalized TEXT
      ''');
    } catch (e) {
      print('Table songs already has the column title_normalized');
    }

    try {
      await db.execute('''
        ALTER TABLE categories
        ADD COLUMN name_normalized TEXT
      ''');
    } catch (e) {
      print('Table categories already has the column name_normalized');
    }

    try {
      await db.execute('''
        ALTER TABLE songbooks
        ADD COLUMN title_normalized TEXT
      ''');
    } catch (e) {
      print('Table songbooks already has the column title_normalized');
    }

    try {
      await db.execute('''
        ALTER TABLE songs
        ADD COLUMN lyrics_normalized TEXT
      ''');
    } catch (e) {
      print('Table songs already has the column lyrics_normalized');
    }

    // Migrate existing data to populate normalized columns
    await _migrateNormalizedColumns(db);

    db.close();
  }

  static Future<Null> updateDatabase(String sqlScript) async {
    await _lock.synchronized(() async {
      Database db = await openDatabase(await _getPath());

      final batch = db.batch();

      for (String statement in sqlScript.split(');')) {
        String trimmedStatement = statement.trim();
        if (trimmedStatement.isNotEmpty) {
          batch.execute('$trimmedStatement);');
        }
      }

      await batch.commit();

      await _migrateNormalizedColumns(db);

      db.close();
    });
  }

  static Future<Null> execute(String sql, {List<dynamic>? arguments}) async {
    await _lock.synchronized(() async {
      Database db = await openDatabase(await _getPath());

      await db.execute(sql, arguments);

      db.close();
    });
  }

  static dynamic rawQuery(String sql, {List<dynamic>? arguments}) async {
    dynamic res;
    await _lock.synchronized(() async {
      Database db = await openDatabase(await _getPath());

      res = await db.rawQuery(sql, arguments);

      db.close();
    });
    return res;
  }

  static dynamic rawInsert(String sql, {List<dynamic>? arguments}) async {
    dynamic res;
    await _lock.synchronized(() async {
      Database db = await openDatabase(await _getPath());

      res = await db.rawInsert(sql, arguments);

      db.close();
    });
    return res;
  }

  static dynamic rawDelete(String sql, {List<dynamic>? arguments}) async {
    dynamic res;
    await _lock.synchronized(() async {
      Database db = await openDatabase(await _getPath());

      res = await db.rawDelete(sql, arguments);

      db.close();
    });

    return res;
  }

  /// Migrates existing data to populate normalized columns for accent-insensitive search
  /// Uses Dart normalization to avoid SQLite parser stack overflow from deeply nested REPLACE functions
  static Future<void> _migrateNormalizedColumns(Database db) async {
    // Check if migration is needed by checking if any normalized column is NULL
    final songsNeedMigration = await db.rawQuery('SELECT COUNT(*) as count FROM songs WHERE title_normalized IS NULL;');
    final categoriesNeedMigration = await db.rawQuery('SELECT COUNT(*) as count FROM categories WHERE name_normalized IS NULL;');
    final songbooksNeedMigration = await db.rawQuery('SELECT COUNT(*) as count FROM songbooks WHERE title_normalized IS NULL;');
    final songsLyricsNeedMigration = await db.rawQuery('SELECT COUNT(*) as count FROM songs WHERE lyrics IS NOT NULL AND lyrics_normalized IS NULL;');

    final songsCount = songsNeedMigration[0]['count'] as int;
    final categoriesCount = categoriesNeedMigration[0]['count'] as int;
    final songbooksCount = songbooksNeedMigration[0]['count'] as int;
    final songsLyricsCount = songsLyricsNeedMigration[0]['count'] as int;

    if (songsCount == 0 && categoriesCount == 0 && songbooksCount == 0 && songsLyricsCount == 0) {
      print('Normalized columns already populated, skipping migration');
      return;
    }

    print('Migrating normalized columns: $songsCount songs, $categoriesCount categories, $songbooksCount songbooks, $songsLyricsCount song lyrics');

    // Update songs - fetch, normalize in Dart, and update
    if (songsCount > 0) {
      final songs = await db.rawQuery('SELECT id, title FROM songs WHERE title_normalized IS NULL;');
      final batch = db.batch();

      for (final song in songs) {
        final normalizedTitle = normalizeText(song['title'] as String);
        batch.rawUpdate(
          'UPDATE songs SET title_normalized = ? WHERE id = ?;',
          [normalizedTitle, song['id']],
        );
      }

      await batch.commit(noResult: true);
      print('Migrated $songsCount songs');
    }

    // Update categories - fetch, normalize in Dart, and update
    if (categoriesCount > 0) {
      final categories = await db.rawQuery('SELECT id, name FROM categories WHERE name_normalized IS NULL;');
      final batch = db.batch();

      for (final category in categories) {
        final normalizedName = normalizeText(category['name'] as String);
        batch.rawUpdate(
          'UPDATE categories SET name_normalized = ? WHERE id = ?;',
          [normalizedName, category['id']],
        );
      }

      await batch.commit(noResult: true);
      print('Migrated $categoriesCount categories');
    }

    // Update songbooks - fetch, normalize in Dart, and update
    if (songbooksCount > 0) {
      final songbooks = await db.rawQuery('SELECT id, title FROM songbooks WHERE title_normalized IS NULL;');
      final batch = db.batch();

      for (final songbook in songbooks) {
        final normalizedTitle = normalizeText(songbook['title'] as String);
        batch.rawUpdate(
          'UPDATE songbooks SET title_normalized = ? WHERE id = ?;',
          [normalizedTitle, songbook['id']],
        );
      }

      await batch.commit(noResult: true);
      print('Migrated $songbooksCount songbooks');
    }

    // Update song lyrics - fetch, normalize in Dart, and update
    if (songsLyricsCount > 0) {
      final songsWithLyrics = await db.rawQuery('SELECT id, lyrics FROM songs WHERE lyrics IS NOT NULL AND lyrics_normalized IS NULL;');
      final batch = db.batch();

      for (final song in songsWithLyrics) {
        final normalizedLyrics = normalizeText(song['lyrics'] as String);
        batch.rawUpdate(
          'UPDATE songs SET lyrics_normalized = ? WHERE id = ?;',
          [normalizedLyrics, song['id']],
        );
      }

      await batch.commit(noResult: true);
      print('Migrated $songsLyricsCount song lyrics');
    }

    print('Normalized columns migration completed');
  }
}
