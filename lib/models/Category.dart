import 'package:songbooksofpraise_app/models/Song.dart';

class Category {
  int id;
  String title;
  String? description;

  List<Category> subcategories;
  List<Song> songs;

  int songCount = 0;
  int categoriesCount = 0;

  Category({
    required this.id,
    required this.title,
    this.description,
    required this.songs,
    required this.subcategories,
  })  : assert(
          (songs.isEmpty) || (subcategories.isEmpty),
          'Category must have either songs or subcategories',
        ),
        assert(
          ((songs.isEmpty) != (subcategories.isEmpty)),
          'Category must have either songs or subcategories, but not both or neither',
        ) {
    songCount = _getSongCount();
    categoriesCount = getCategoriesCount();
  }

  int _getSongCount() {
    int count = songs.length;

    int recursiveSongCount(Category category) {
      int total = 0;

      total += category.songs.length;

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
      count += category.songs.length;
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
