class Song {
  int id;
  int number;
  bool chords;
  String title;
  String lyrics;
  String? author;

  Song({
    required this.id,
    required this.number,
    required this.chords,
    required this.title,
    required this.lyrics,
    this.author,
  });
}
