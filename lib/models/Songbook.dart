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
  bool updatedAvailable = false;

  Songbook({
    required this.id,
    required this.title,
    // required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
    this.isInstalled = false,
    this.updatedAvailable = false,
    this.songCount = 0,
  }) {
    // songCount = _getSongCount();
    categoriesCount = getCategoriesCount();
  }

  static Future<List<Songbook>> getInstalled() async {
    final rows = await DB.rawQuery('''
      SELECT 
        *,
        true as isInstalled,
        (SELECT COUNT(*) FROM songs WHERE songs.songbook_id = songbooks.id) as song_count 
      FROM songbooks
    ''');
    return Songbook.fromJson(rows);
  }

  static Future<List<Songbook>> fromJson(List<dynamic> json) async {
    List<dynamic> installed = await DB.rawQuery('SELECT id, updated_at FROM songbooks;');
    Map<int, DateTime> installedMap = {for (var item in installed) item['id']: DateTime.parse(item['updated_at'])};

    return json.map((item) {
      DateTime updatedAt = DateTime.parse(item['updated_at']);
      return Songbook(
        id: item['id'],
        title: item['title'],
        // description: item['description'],
        createdAt: DateTime.parse(item['created_at']),
        updatedAt: updatedAt,
        songCount: item['song_count'],
        isInstalled: installedMap.containsKey(item['id']),
        updatedAvailable: installedMap.containsKey(item['id']) ? updatedAt.isAfter(installedMap[item['id']]!) : false,
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
}
