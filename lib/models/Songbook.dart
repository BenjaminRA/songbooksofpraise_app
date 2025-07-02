import 'package:songbooksofpraise_app/models/Category.dart';
import 'package:songbooksofpraise_app/models/Song.dart';

class Songbook {
  int id;
  String title;
  String description;
  bool enumerated;
  List<Category> categories = [];

  int songCount = 0;
  int categoriesCount = 0;

  DateTime createdAt;
  DateTime updatedAt;

  Songbook(
      {required this.id,
      required this.title,
      required this.description,
      required this.enumerated,
      required this.createdAt,
      required this.updatedAt,
      required this.categories}) {
    songCount = _getSongCount();
    categoriesCount = getCategoriesCount();
  }

  static List<Songbook> getInstalled() {
    return [
      Songbook(
        id: 1,
        title: 'Hymns of Joy',
        description: 'A collection of joyful hymns.',
        enumerated: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        categories: [
          Category(
            id: 1,
            title: 'Morning Hymns',
            description: 'Songs to start your day with joy.',
            songs: [],
            subcategories: [
              Category(
                id: 11,
                title: 'Sunrise',
                description: 'Hymns for the early morning.',
                songs: [
                  Song(
                    id: 1,
                    number: 1,
                    chords: true,
                    title: 'Awake with Joy',
                    lyrics: 'Lyrics for Awake with Joy',
                  ),
                ],
                subcategories: [],
              ),
              Category(
                id: 12,
                title: 'Early Light',
                songs: [
                  Song(
                    id: 2,
                    number: 2,
                    chords: false,
                    title: 'Light of Day',
                    lyrics: 'Lyrics for Light of Day',
                  ),
                ],
                subcategories: [],
              ),
            ],
          ),
          Category(
            id: 2,
            title: 'Evening Hymns',
            description: 'Reflective hymns for the evening.',
            songs: [
              Song(
                id: 3,
                number: 3,
                chords: true,
                title: 'Restful Night',
                lyrics: 'Lyrics for Restful Night',
              ),
            ],
            subcategories: [],
          ),
        ],
      ),
      Songbook(
        id: 2,
        title: 'Classic Worship',
        description: 'Traditional worship songs.',
        enumerated: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        categories: [
          Category(
            id: 3,
            title: 'Old Testament',
            description: 'Songs inspired by the Old Testament.',
            songs: [],
            subcategories: [
              Category(
                id: 31,
                title: 'Psalms',
                description: 'Songs from the book of Psalms.',
                songs: [
                  Song(
                    id: 4,
                    number: 4,
                    chords: false,
                    title: 'Psalm of David',
                    lyrics: 'Lyrics for Psalm of David',
                  ),
                ],
                subcategories: [],
              ),
              Category(
                id: 32,
                title: 'Proverbs',
                songs: [
                  Song(
                    id: 5,
                    number: 5,
                    chords: true,
                    title: 'Wisdom Song',
                    lyrics: 'Lyrics for Wisdom Song',
                  ),
                ],
                subcategories: [],
              ),
            ],
          ),
          Category(
            id: 4,
            title: 'New Testament',
            songs: [
              Song(
                id: 6,
                number: 6,
                chords: true,
                title: 'Grace Hymn',
                lyrics: 'Lyrics for Grace Hymn',
              ),
            ],
            subcategories: [],
          ),
        ],
      ),
      Songbook(
        id: 3,
        title: 'Modern Praise',
        description: 'Contemporary praise songs.',
        enumerated: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        categories: [
          Category(
            id: 5,
            title: 'Upbeat',
            description: 'Energetic and lively songs.',
            songs: [],
            subcategories: [
              Category(
                id: 51,
                title: 'Youth',
                songs: [],
                subcategories: [
                  Category(
                    id: 551,
                    title: 'Super Youth',
                    description: 'Songs for youth groups.',
                    songs: [
                      Song(
                        id: 7,
                        number: 7,
                        chords: true,
                        title: 'Rise Up',
                        lyrics: 'Lyrics for Rise Up',
                      ),
                    ],
                    subcategories: [],
                  )
                ],
              ),
              Category(
                id: 52,
                title: 'Dance',
                songs: [
                  Song(
                    id: 8,
                    number: 8,
                    chords: false,
                    title: 'Dance for Him',
                    lyrics: 'Lyrics for Dance for Him',
                  ),
                ],
                subcategories: [],
              ),
            ],
          ),
          Category(
            id: 6,
            title: 'Reflective',
            songs: [
              Song(
                id: 9,
                number: 9,
                chords: true,
                title: 'Quiet Praise',
                lyrics: 'Lyrics for Quiet Praise',
              ),
            ],
            subcategories: [],
          ),
        ],
      ),
      Songbook(
        id: 4,
        title: 'Children\'s Songs',
        description: 'Songs for children and families.',
        enumerated: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        categories: [
          Category(
            id: 7,
            title: 'Bedtime',
            description: 'Soothing songs for bedtime.',
            songs: [],
            subcategories: [
              Category(
                id: 71,
                title: 'Lullabies',
                songs: [
                  Song(
                    id: 10,
                    number: 10,
                    chords: false,
                    title: 'Sleep Tight',
                    lyrics: 'Lyrics for Sleep Tight',
                  ),
                ],
                subcategories: [],
              ),
            ],
          ),
          Category(
            id: 8,
            title: 'Playtime',
            songs: [
              Song(
                id: 11,
                number: 11,
                chords: true,
                title: 'Jump and Sing',
                lyrics: 'Lyrics for Jump and Sing',
              ),
            ],
            subcategories: [],
          ),
        ],
      ),
      Songbook(
        id: 5,
        title: 'Special Occasions',
        description: 'Songs for weddings, funerals, and more.',
        enumerated: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        categories: [
          Category(
            id: 9,
            title: 'Weddings',
            description: 'Songs for wedding ceremonies.',
            songs: [],
            subcategories: [
              Category(
                id: 91,
                title: 'Ceremony',
                songs: [
                  Song(
                    id: 12,
                    number: 12,
                    chords: true,
                    title: 'Wedding March',
                    lyrics: 'Lyrics for Wedding March',
                  ),
                ],
                subcategories: [],
              ),
            ],
          ),
          Category(
            id: 10,
            title: 'Funerals',
            songs: [
              Song(
                id: 13,
                number: 13,
                chords: false,
                title: 'Farewell',
                lyrics: 'Lyrics for Farewell',
              ),
            ],
            subcategories: [],
          ),
        ],
      ),
      Songbook(
        id: 6,
        title: 'Seasonal Songs',
        description: 'Songs for holidays and seasons.',
        enumerated: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        categories: [
          Category(
            id: 11,
            title: 'Christmas',
            description: 'Carols and Christmas hymns.',
            songs: [],
            subcategories: [
              Category(
                id: 111,
                title: 'Carols',
                songs: [
                  Song(
                    id: 14,
                    number: 14,
                    chords: true,
                    title: 'Silent Night',
                    lyrics: 'Lyrics for Silent Night',
                  ),
                ],
                subcategories: [],
              ),
            ],
          ),
          Category(
            id: 12,
            title: 'Easter',
            songs: [
              Song(
                id: 15,
                number: 15,
                chords: true,
                title: 'He Is Risen',
                lyrics: 'Lyrics for He Is Risen',
              ),
            ],
            subcategories: [],
          ),
        ],
      ),
    ];
  }

  int _getSongCount() {
    int count = 0;

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

    for (var category in categories) {
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

    for (var category in categories) {
      count += recursiveCategoryCount(category);
    }

    return count;
  }

  // factory Songbook.byId(int id) {
  //   return Songbook(
  //     id: json['id'],
  //     title: json['title'],
  //     description: json['description'],
  //     enumerated: json['enumerated'] ?? false,
  //     createdAt: DateTime.parse(json['createdAt']),
  //     updatedAt: DateTime.parse(json['updatedAt']),
  //   );
  // }

  // factory Songbook.fromJson(Map<String, dynamic> json) {
  //   return Songbook(
  //     id: json['id'],
  //     title: json['title'],
  //     description: json['description'],
  //     enumerated: json['enumerated'] ?? false,
  //     createdAt: DateTime.parse(json['createdAt']),
  //     updatedAt: DateTime.parse(json['updatedAt']),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'description': description,
  //     'coverImageUrl': coverImageUrl,
  //     'songIds': songIds,
  //   };
  // }
}
