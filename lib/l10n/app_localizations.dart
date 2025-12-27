import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// The language of the application
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// Home Page label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Songbooks Page label
  ///
  /// In en, this message translates to:
  /// **'Songbooks'**
  String get songbooks;

  /// Churches Page label
  ///
  /// In en, this message translates to:
  /// **'Churches'**
  String get churches;

  /// Settings Page label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Display section title in settings
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// Text size setting label
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// Text size setting description
  ///
  /// In en, this message translates to:
  /// **'Adjust lyrics text size'**
  String get adjustLyricsTextSize;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Theme setting description
  ///
  /// In en, this message translates to:
  /// **'Choose app appearance'**
  String get chooseAppAppearance;

  /// Keep screen on setting label
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On'**
  String get keepScreenOn;

  /// Keep screen on setting description
  ///
  /// In en, this message translates to:
  /// **'Prevent screen from sleeping'**
  String get preventScreenFromSleeping;

  /// Small text size option
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// Medium text size option
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Large text size option
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Music and audio section title in settings
  ///
  /// In en, this message translates to:
  /// **'Music & Audio'**
  String get musicAndAudio;

  /// Default transpose setting label
  ///
  /// In en, this message translates to:
  /// **'Default Transpose'**
  String get defaultTranspose;

  /// Default transpose setting description
  ///
  /// In en, this message translates to:
  /// **'Automatic Key Adjustment'**
  String get automaticKeyAdjustment;

  /// Show chords by default setting label
  ///
  /// In en, this message translates to:
  /// **'Show Chords by Default'**
  String get showChordsByDefault;

  /// Show chords by default setting description
  ///
  /// In en, this message translates to:
  /// **'Display chords when opening songs'**
  String get displayChordsWhenOpeningSongs;

  /// About and support section title in settings
  ///
  /// In en, this message translates to:
  /// **'About & Support'**
  String get aboutAndSupport;

  /// About option in settings
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Privacy policy option in settings
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Announcements option in settings
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// Contact us option in settings
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// Search bar placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search hymns, songs, or numbers...'**
  String get searchHymnsSongsOrNumbers;

  /// Explore section title
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// Browse option in explore section
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// Categories label in explore section
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Manage label in explore section
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// Recent option in explore section
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// Last played label in explore section
  ///
  /// In en, this message translates to:
  /// **'Last played'**
  String get lastPlayed;

  /// Favorites option in explore section
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Songs count label
  ///
  /// In en, this message translates to:
  /// **'{count} songs'**
  String songsCount(int count);

  /// Recently played section title
  ///
  /// In en, this message translates to:
  /// **'Recently Played'**
  String get recentlyPlayed;

  /// View all button text
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Popular this week section title
  ///
  /// In en, this message translates to:
  /// **'Popular This Week'**
  String get popularThisWeek;

  /// Hymn category label
  ///
  /// In en, this message translates to:
  /// **'Hymn'**
  String get hymn;

  /// Plays count label
  ///
  /// In en, this message translates to:
  /// **'{count} plays'**
  String playsCount(int count);

  /// Placeholder text for songbook search bar
  ///
  /// In en, this message translates to:
  /// **'Search available songbooks'**
  String get searchAvailableSongbooks;

  /// Installed tab label
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// Available tab label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Installed tab with count
  ///
  /// In en, this message translates to:
  /// **'Installed ({count})'**
  String installedCount(int count);

  /// Available tab with count
  ///
  /// In en, this message translates to:
  /// **'Available ({count})'**
  String availableCount(int count);

  /// Indicates that a songbook is installed
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installedSingular;

  /// Indicates that a songbook is available
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableSingular;

  /// Update button text
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Updating button text
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get updating;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Download button text
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Hymns count label
  ///
  /// In en, this message translates to:
  /// **'{count} hymns'**
  String hymnsCount(int count);

  /// Last updated date label
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(String date);

  /// Browse categories section title
  ///
  /// In en, this message translates to:
  /// **'Browse Categories'**
  String get browseCategories;

  /// Description for browsing categories
  ///
  /// In en, this message translates to:
  /// **'Explore hymns organized by themes and occasions'**
  String get exploreCategoriesDescription;

  /// Search placeholder for category search
  ///
  /// In en, this message translates to:
  /// **'Search categories'**
  String get searchCategories;

  /// Search placeholder for song search
  ///
  /// In en, this message translates to:
  /// **'Search songs'**
  String get searchSongs;

  /// Back button text to return to songbooks
  ///
  /// In en, this message translates to:
  /// **'Back to Songbooks'**
  String get backToSongbooks;

  /// Back button text to return to categories
  ///
  /// In en, this message translates to:
  /// **'Back to Categories'**
  String get backToCategories;

  /// Toast message when songbook is downloaded
  ///
  /// In en, this message translates to:
  /// **'{title} downloaded successfully!'**
  String downloadedSuccessfully(String title);

  /// Toast message when songbook is updated
  ///
  /// In en, this message translates to:
  /// **'{title} updated successfully!'**
  String updatedSuccessfully(String title);

  /// Toast message when songbook is deleted
  ///
  /// In en, this message translates to:
  /// **'{title} deleted successfully!'**
  String deletedSuccessfully(String title);

  /// Chords label
  ///
  /// In en, this message translates to:
  /// **'Chords'**
  String get chords;

  /// Sheet music label
  ///
  /// In en, this message translates to:
  /// **'Sheet'**
  String get sheet;

  /// Verse label
  ///
  /// In en, this message translates to:
  /// **'Verse'**
  String get verse;

  /// Chorus label
  ///
  /// In en, this message translates to:
  /// **'Chorus'**
  String get chorus;

  /// Bridge label
  ///
  /// In en, this message translates to:
  /// **'Bridge'**
  String get bridge;

  /// All category label
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Generic category description 1
  ///
  /// In en, this message translates to:
  /// **'Explore the hymns in this category.'**
  String get genericCategoryDescription1;

  /// Generic category description 2
  ///
  /// In en, this message translates to:
  /// **'A collection of songs for inspiration and worship.'**
  String get genericCategoryDescription2;

  /// Generic category description 3
  ///
  /// In en, this message translates to:
  /// **'Discover hymns organized by this theme.'**
  String get genericCategoryDescription3;

  /// Generic category description 4
  ///
  /// In en, this message translates to:
  /// **'Songs gathered for special moments and occasions.'**
  String get genericCategoryDescription4;

  /// Generic category description 5
  ///
  /// In en, this message translates to:
  /// **'Enjoy a variety of hymns selected for this category.'**
  String get genericCategoryDescription5;

  /// Generic category description 6
  ///
  /// In en, this message translates to:
  /// **'A selection of meaningful hymns.'**
  String get genericCategoryDescription6;

  /// Generic category description 7
  ///
  /// In en, this message translates to:
  /// **'Find uplifting songs in this section.'**
  String get genericCategoryDescription7;

  /// Generic category description 8
  ///
  /// In en, this message translates to:
  /// **'Hymns curated for your spiritual journey.'**
  String get genericCategoryDescription8;

  /// Generic category description 9
  ///
  /// In en, this message translates to:
  /// **'Browse songs that fit this category.'**
  String get genericCategoryDescription9;

  /// Generic category description 10
  ///
  /// In en, this message translates to:
  /// **'A group of hymns to enrich your worship experience.'**
  String get genericCategoryDescription10;

  /// Generic category description 11
  ///
  /// In en, this message translates to:
  /// **'Explore the collection of hymns in this category.'**
  String get genericCategoryDescription11;

  /// Generic category description 12
  ///
  /// In en, this message translates to:
  /// **'Songs to inspire and uplift.'**
  String get genericCategoryDescription12;

  /// Generic category description 13
  ///
  /// In en, this message translates to:
  /// **'A special selection of hymns for this topic.'**
  String get genericCategoryDescription13;

  /// Generic category description 14
  ///
  /// In en, this message translates to:
  /// **'Discover new favorites in this category.'**
  String get genericCategoryDescription14;

  /// Generic category description 15
  ///
  /// In en, this message translates to:
  /// **'Meaningful songs for every occasion.'**
  String get genericCategoryDescription15;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
