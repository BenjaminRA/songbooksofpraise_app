import 'dart:io';
import 'package:sqflite/sqflite.dart';

class DB {
  static String? _dbPath;

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
        PRIMARY KEY (song_id),
        FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE
      );
    ''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS favorite_songbooks (
        songbook_id INTEGER NOT NULL,
        PRIMARY KEY (songbook_id),
        FOREIGN KEY (songbook_id) REFERENCES songbooks(id) ON DELETE CASCADE
      );
    ''');

    await batch.commit();

    db.close();
  }

  static Future<Null> updateDatabase(String sqlScript) async {
    Database db = await openDatabase(await _getPath());

    final batch = db.batch();

    for (String statement in sqlScript.split(');')) {
      String trimmedStatement = statement.trim();
      if (trimmedStatement.isNotEmpty) {
        batch.execute('$trimmedStatement);');
      }
    }

    await batch.commit();

    db.close();
  }

  static Future<Null> execute(String sql, {List<dynamic>? arguments}) async {
    Database db = await openDatabase(await _getPath());

    await db.execute(sql, arguments);

    db.close();
  }

  static dynamic rawQuery(String sql, {List<dynamic>? arguments}) async {
    Database db = await openDatabase(await _getPath());

    dynamic res = await db.rawQuery(sql, arguments);

    db.close();

    return res;
  }

  static dynamic rawInsert(String sql, {List<dynamic>? arguments}) async {
    Database db = await openDatabase(await _getPath());

    dynamic res = await db.rawInsert(sql, arguments);

    db.close();

    return res;
  }

  static dynamic rawDelete(String sql, {List<dynamic>? arguments}) async {
    Database db = await openDatabase(await _getPath());

    dynamic res = await db.rawDelete(sql, arguments);

    db.close();

    return res;
  }
}
