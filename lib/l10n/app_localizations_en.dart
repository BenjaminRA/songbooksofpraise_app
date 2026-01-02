// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get home => 'Home';

  @override
  String get songbooks => 'Songbooks';

  @override
  String get churches => 'Churches';

  @override
  String get settings => 'Settings';

  @override
  String get display => 'Display';

  @override
  String get textSize => 'Text Size';

  @override
  String get adjustLyricsTextSize => 'Adjust lyrics text size';

  @override
  String get theme => 'Theme';

  @override
  String get chooseAppAppearance => 'Choose app appearance';

  @override
  String get keepScreenOn => 'Keep Screen On';

  @override
  String get preventScreenFromSleeping => 'Prevent screen from sleeping';

  @override
  String get small => 'Small';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get musicAndAudio => 'Music & Audio';

  @override
  String get defaultTranspose => 'Default Transpose';

  @override
  String get automaticKeyAdjustment => 'Automatic Key Adjustment';

  @override
  String get showChordsByDefault => 'Show Chords by Default';

  @override
  String get displayChordsWhenOpeningSongs =>
      'Display chords when opening songs';

  @override
  String get aboutAndSupport => 'About & Support';

  @override
  String get about => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get announcements => 'Announcements';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get searchHymnsSongsOrNumbers => 'Search hymns, songs, or numbers...';

  @override
  String get explore => 'Explore';

  @override
  String get browse => 'Browse';

  @override
  String get categories => 'Categories';

  @override
  String get manage => 'Manage';

  @override
  String get recent => 'Recent';

  @override
  String get lastPlayed => 'Last played';

  @override
  String get favorites => 'Favorites';

  @override
  String songsCount(int count) {
    return '$count songs';
  }

  @override
  String get recentlyPlayed => 'Recently Played';

  @override
  String get viewAll => 'View All';

  @override
  String get popularThisWeek => 'Popular This Week';

  @override
  String get hymn => 'Hymn';

  @override
  String playsCount(int count) {
    return '$count plays';
  }

  @override
  String get searchAvailableSongbooks => 'Search available songbooks';

  @override
  String get installed => 'Installed';

  @override
  String get available => 'Available';

  @override
  String installedCount(int count) {
    return 'Installed ($count)';
  }

  @override
  String availableCount(int count) {
    return 'Available ($count)';
  }

  @override
  String get installedSingular => 'Installed';

  @override
  String get availableSingular => 'Available';

  @override
  String get update => 'Update';

  @override
  String get updating => 'Updating';

  @override
  String get delete => 'Delete';

  @override
  String get download => 'Download';

  @override
  String hymnsCount(int count) {
    return '$count hymns';
  }

  @override
  String lastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get browseCategories => 'Browse Categories';

  @override
  String get exploreCategoriesDescription =>
      'Explore hymns organized by themes and occasions';

  @override
  String get searchCategories => 'Search categories';

  @override
  String get searchSongs => 'Search songs';

  @override
  String get backToSongbooks => 'Back to Songbooks';

  @override
  String get backToCategories => 'Back to Categories';

  @override
  String downloadedSuccessfully(String title) {
    return '$title downloaded successfully!';
  }

  @override
  String updatedSuccessfully(String title) {
    return '$title updated successfully!';
  }

  @override
  String deletedSuccessfully(String title) {
    return '$title deleted successfully!';
  }

  @override
  String get chords => 'Chords';

  @override
  String get sheet => 'Sheet';

  @override
  String get verse => 'Verse';

  @override
  String get chorus => 'Chorus';

  @override
  String get bridge => 'Bridge';

  @override
  String get all => 'All';

  @override
  String get genericCategoryDescription1 =>
      'Explore the hymns in this category.';

  @override
  String get genericCategoryDescription2 =>
      'A collection of songs for inspiration and worship.';

  @override
  String get genericCategoryDescription3 =>
      'Discover hymns organized by this theme.';

  @override
  String get genericCategoryDescription4 =>
      'Songs gathered for special moments and occasions.';

  @override
  String get genericCategoryDescription5 =>
      'Enjoy a variety of hymns selected for this category.';

  @override
  String get genericCategoryDescription6 => 'A selection of meaningful hymns.';

  @override
  String get genericCategoryDescription7 =>
      'Find uplifting songs in this section.';

  @override
  String get genericCategoryDescription8 =>
      'Hymns curated for your spiritual journey.';

  @override
  String get genericCategoryDescription9 =>
      'Browse songs that fit this category.';

  @override
  String get genericCategoryDescription10 =>
      'A group of hymns to enrich your worship experience.';

  @override
  String get genericCategoryDescription11 =>
      'Explore the collection of hymns in this category.';

  @override
  String get genericCategoryDescription12 => 'Songs to inspire and uplift.';

  @override
  String get genericCategoryDescription13 =>
      'A special selection of hymns for this topic.';

  @override
  String get genericCategoryDescription14 =>
      'Discover new favorites in this category.';

  @override
  String get genericCategoryDescription15 =>
      'Meaningful songs for every occasion.';

  @override
  String get neverPlayed => 'Never played';

  @override
  String playedOnDate(int year, int month, int day) {
    return 'Played $year/$month/$day';
  }

  @override
  String get playedYesterday => 'Played yesterday';

  @override
  String playedDaysAgo(int days) {
    return 'Played $days days ago';
  }

  @override
  String get playedOneHourAgo => 'Played 1 hour ago';

  @override
  String playedHoursAgo(int hours) {
    return 'Played $hours hours ago';
  }

  @override
  String get playedOneMinuteAgo => 'Played 1 minute ago';

  @override
  String playedMinutesAgo(int minutes) {
    return 'Played $minutes minutes ago';
  }

  @override
  String get playedJustNow => 'Played just now';
}
