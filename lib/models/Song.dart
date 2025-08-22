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
}
