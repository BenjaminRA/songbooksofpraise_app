import 'package:songbooksofpraise_app/models/Song.dart';

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
    categoriesCount = getCategoriesCount();
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

    for (Category category in subcategories) {
      count += recursiveCategoryCount(category);
    }

    return count;
  }
}
