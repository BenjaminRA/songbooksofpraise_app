import 'package:songbooksofpraise_app/db/DB.dart';
import 'package:songbooksofpraise_app/models/Category.dart';

class Songbook {
  int id;
  String title;
  // String description;
  List<Category> categories = [];

  int songCount = 0;
  int categoriesCount = 0;

  DateTime createdAt;
  DateTime updatedAt;

  bool isInstalled = false;
  bool updateAvailable = false;
  bool isDownloading = false;

  Songbook({
    required this.id,
    required this.title,
    // required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
    this.isInstalled = false,
    this.updateAvailable = false,
    this.songCount = 0,
  }) {
    // songCount = _getSongCount();
    categoriesCount = getCategoriesCount();
  }

  static DateTime _stripMilliseconds(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }

  static Future<List<Songbook>> getInstalled() async {
    final rows = await DB.rawQuery('''
      SELECT 
        *,
        true as isInstalled,
        (SELECT COUNT(*) FROM songs WHERE songs.songbook_id = songbooks.id) as song_count 
      FROM songbooks
    ''');

    List<Songbook> songbooks = [];

    for (dynamic row in rows) {
      DateTime updatedAt = _stripMilliseconds(DateTime.parse(row['updated_at']));

      songbooks.add(
        Songbook(
          id: row['id'],
          title: row['title'],
          // description: item['description'],
          createdAt: DateTime.parse(row['created_at']),
          updatedAt: updatedAt,
          songCount: row['song_count'],
          isInstalled: true,
          updateAvailable: false,
          categories: [
            Category(
              id: -1,
              name: 'All',
              songs: [],
              subcategories: [],
              songbookID: row['id'],
              songCount: row['song_count'],
            ),
            ...await Category.getCategoriesBySongbookID(row['id'])
          ],
        ),
      );
    }

    return songbooks;
  }

  static Future<List<Songbook>> fromJson(List<dynamic> json) async {
    List<dynamic> installed = await DB.rawQuery('SELECT id, updated_at FROM songbooks;');
    Map<int, DateTime> installedMap = {for (var item in installed) item['id']: _stripMilliseconds(DateTime.parse(item['updated_at']))};

    return json.map((item) {
      DateTime updatedAt = _stripMilliseconds(DateTime.parse(item['updated_at']));

      return Songbook(
        id: item['id'],
        title: item['title'],
        // description: item['description'],
        createdAt: DateTime.parse(item['created_at']),
        updatedAt: updatedAt,
        songCount: item['song_count'],
        isInstalled: installedMap.containsKey(item['id']),
        updateAvailable: installedMap.containsKey(item['id']) ? updatedAt.isAfter(installedMap[item['id']]!) : false,
        categories: item['categories'] != null ? (item['categories'] as List<dynamic>).map((cat) => Category.fromJson(cat)).toList() : [],
      );
    }).toList();
  }

  int getCategoriesCount() {
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

    for (var category in categories) {
      count += recursiveCategoryCount(category);
    }

    return count;
  }

  Future<void> delete() {
    return DB.execute('DELETE FROM songbooks WHERE id = ?;', arguments: [id]);
  }
}
