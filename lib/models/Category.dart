import 'package:songbooksofpraise_app/db/DB.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';

class Category {
  int id;
  String name;
  // String? description;
  int songbookID;

  List<Category> subcategories;
  List<Song> songs;

  int songCount = 0;
  int categoriesCount = 0;

  Category({
    required this.id,
    required this.name,
    // this.description,
    required this.songs,
    required this.subcategories,
    this.songCount = 0,
    required this.songbookID,
  })
  // : assert(
  //         (songs.isEmpty) || (subcategories.isEmpty),
  //         'Category must have either songs or subcategories',
  //       ),
  //       assert(
  //         ((songs.isEmpty) != (subcategories.isEmpty)),
  //         'Category must have either songs or subcategories, but not both or neither',
  //       )
  {
    songCount = _getSongCount();
    categoriesCount = _getCategoriesCount();
  }

  /// Gets all `categories` and `subcategories` for a given songbook ID from the database in local storage.
  static Future<List<Category>> getCategoriesBySongbookID(int songbookID) async {
    Future<List<Category>> getSubCategoriesRecursive(int categoryID) async {
      final subcategoryRows = await DB.rawQuery('''
        SELECT 
          *,
          (SELECT COUNT(*) FROM song_categories WHERE category_id = categories.id) as song_count  
        FROM categories 
        WHERE parent_category_id = ?;
      ''', arguments: [categoryID]);

      List<Category> subcategories = [];

      for (dynamic row in subcategoryRows) {
        List<Category> children = await getSubCategoriesRecursive(row['id']);

        Category subcategory = Category(
          id: row['id'],
          name: row['name'],
          // description: row['description'],
          songs: [],
          songCount: row['song_count'],
          subcategories: children,
          songbookID: row['songbook_id'],
        );

        subcategories.add(subcategory);
      }

      return subcategories;
    }

    final rows = await DB.rawQuery('''
      SELECT 
        *,
        (SELECT COUNT(*) FROM song_categories WHERE category_id = categories.id) as song_count 
      FROM categories 
      WHERE songbook_id = ? AND parent_category_id IS NULL;
    ''', arguments: [songbookID]);

    List<Category> categories = [];

    for (dynamic row in rows) {
      List<Category> subcategories = await getSubCategoriesRecursive(row['id']);

      Category category = Category(
        id: row['id'],
        name: row['name'],
        // description: row['description'],
        songs: [],
        songCount: row['song_count'],
        subcategories: subcategories,
        songbookID: row['songbook_id'],
      );

      categories.add(category);
    }

    return categories;
  }

  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      // description: json['description'],
      songs: (json['songs'] as List<dynamic>?)?.map((item) => Song.fromJson(item)).toList() ?? [],
      subcategories: (json['children'] as List<dynamic>?)?.map((item) => Category.fromJson(item)).toList() ?? [],
      songCount: json['song_count'] ?? 0,
      songbookID: json['songbook_id'],
    );
  }

  /// Fetch a `category` by `id` from database and brings every song from the database in local storage.
  /// If the `id` is -1, it fetches all songs for the given `songbookID`.
  static Future<Category?> getCategoryByID(int id, [int? songbookID]) async {
    assert(
      id != -1 || songbookID != null,
      'songbookID must be provided when fetching the "All" category with id -1',
    );

    // Special case for "All" category
    if (id == -1) {
      // If Songbook doesn't exists, we go to the API returning null here
      if (await DB.rawQuery('SELECT * FROM songbooks WHERE id = ?;', arguments: [songbookID]).then((rows) => rows.isEmpty)) return null;

      final category = Category(
        id: -1,
        name: 'All',
        songs: [],
        subcategories: [],
        songbookID: songbookID!,
        songCount: await DB.rawQuery('SELECT COUNT(*) as song_count FROM songs WHERE songbook_id = ?;',
            arguments: [songbookID]).then((value) => value[0]['song_count']),
      );

      final songRows = await DB.rawQuery('SELECT * FROM songs WHERE songbook_id = ?;', arguments: [songbookID]);

      for (dynamic songRow in songRows) {
        category.songs.add(Song.fromJson(songRow));
      }

      return category;
    } else {
      final row = await DB.rawQuery('''
        SELECT 
          *,
          (SELECT COUNT(*) FROM song_categories WHERE category_id = categories.id) as song_count 
        FROM categories 
        WHERE id = ?;
      ''', arguments: [id]);

      if (row.isEmpty) {
        return null;
      }

      final category = Category(
        id: row[0]['id'],
        name: row[0]['name'],
        // description: row[0]['description'],
        songs: [],
        songCount: row[0]['song_count'],
        subcategories: [],
        songbookID: row[0]['songbook_id'],
      );

      final songRows = await DB.rawQuery('''
        SELECT songs.* FROM songs 
        INNER JOIN song_categories ON songs.id = song_categories.song_id 
        WHERE song_categories.category_id = ?;
      ''', arguments: [id]);

      for (dynamic songRow in songRows) {
        category.songs.add(Song.fromJson(songRow));
      }

      return category;
    }
  }

  int _getSongCount() {
    int count = songCount;

    int recursiveSongCount(Category category) {
      int total = 0;

      total += category.songCount;

      if (category.subcategories.isNotEmpty) {
        for (var subCategory in category.subcategories) {
          if (subCategory.subcategories.isNotEmpty) {
            total += recursiveSongCount(subCategory);
          }
        }
      }

      return total;
    }

    for (Category category in subcategories) {
      count += category.songCount;
      if (category.subcategories.isNotEmpty) {
        count += recursiveSongCount(category);
      }
    }

    return count;
  }

  int _getCategoriesCount() {
    int count = 0;

    int recursiveCategoryCount(Category category) {
      int total = 1;

      if (category.subcategories.isNotEmpty) {
        for (var subCategory in category.subcategories) {
          total += recursiveCategoryCount(subCategory);
        }
      }

      return total;
    }

    for (Category category in subcategories) {
      count += recursiveCategoryCount(category);
    }

    return count;
  }
}
