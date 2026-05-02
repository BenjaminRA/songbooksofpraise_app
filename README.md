# Songbooks of Praise

A Flutter hymnal app for browsing, searching, and singing from digital songbooks. Supports chord notation, vocal arrangements, sheet music, and accent-insensitive search across titles and lyrics.

## Features

- **Multiple songbooks** — browse and download songbook collections
- **Search** — accent and special-character insensitive search across song titles, lyrics, categories, and songbooks; highlights matched text including lyric excerpts
- **Chord notation** — display chords in Letter (English) or Solfège (Spanish) notation with real-time transposition
- **Vocal arrangements** — SATB voice parts (soprano, alto, tenor, bass) plus full-arrangement audio
- **Sheet music** — pinch-to-zoom sheet music viewer
- **Favorites** — mark songs as favorites and filter by them
- **Settings** — adjustable font size, dark/light mode, keep-screen-on toggle, default chord and sheet music visibility, scroll speed
- **Offline-first** — all content stored locally in SQLite; no internet required after download
- **Localization** — English and Spanish UI

## Tech Stack

| Area             | Library                                                                     |
| ---------------- | --------------------------------------------------------------------------- |
| Framework        | Flutter ≥ 3.1.3                                                             |
| State management | `provider ^6.1.5`                                                           |
| Local database   | `sqflite ^2.4.2`                                                            |
| Preferences      | `shared_preferences ^2.5.3`                                                 |
| HTTP             | `http ^1.5.0`                                                               |
| Encryption       | `encrypt ^5.0.3`, `pointycastle ^3.9.1`, `crypto ^3.0.6`                    |
| Localization     | `flutter_localizations` + `intl`                                            |
| UI               | `flutter_spinkit`, `skeletonizer`, `font_awesome_flutter`, `toastification` |
| Media            | `photo_view ^0.15.0`, `url_launcher ^6.3.1`, `wakelock_plus ^1.4.0`         |
| Concurrency      | `synchronized ^3.4.0`                                                       |

## Project Structure

```
lib/
├── main.dart               # App entry point, theme, providers
├── router.dart             # Navigation utilities
├── api/                    # HTTP API client
├── auth/                   # Authentication logic
├── components/             # Shared UI widgets
├── db/
│   └── DB.dart             # SQLite database: init, migrations, CRUD
├── helpers/                # Utilities (navigation, text normalization, …)
├── l10n/                   # ARB localization files
├── models/                 # Data models: Song, Category, Songbook, Chord, SearchResult
├── pages/
│   ├── RootPage.dart       # App shell with bottom navigation
│   ├── SongPage/           # Song detail, chord rendering, playback controls
│   ├── SongSearch/         # Search page with filters and highlighted results
│   └── Tabs/               # Home, Songbooks, Churches, Settings tabs
└── Providers/              # SettingsProvider, AppBarProvider, TabNavigatorProvider
```

## Database Schema

| Table             | Purpose                                                                  |
| ----------------- | ------------------------------------------------------------------------ |
| `songbooks`       | Songbook collections                                                     |
| `categories`      | Hierarchical song categories (self-referential via `parent_category_id`) |
| `songs`           | Songs with lyrics, media URLs, voice parts, transposition, scroll speed  |
| `song_categories` | Many-to-many: songs ↔ categories                                         |
| `favorite_songs`  | User's saved favorites                                                   |

Normalized columns (`title_normalized`, `name_normalized`, `lyrics_normalized`) power accent-insensitive search via Dart-side `normalizeText()`.

## Getting Started

### Prerequisites

- Flutter ≥ 3.1.3
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode for device targets

### Install & Run

```bash
flutter pub get
flutter run
```

### Build

**Android:**

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**

```bash
flutter build ios --release
```

## Android Details

| Field          | Value                       |
| -------------- | --------------------------- |
| Application ID | `com.songbooksofpraise.app` |
| Min SDK        | 21                          |
| Target SDK     | 34                          |
| Version        | 1.2.5 (build 125)           |

Release signing is configured via `android/key.properties` (not committed to source control).

## Localization

Localization files live in `lib/l10n/`. To regenerate after editing ARB files:

```bash
flutter gen-l10n
```

Configured via `l10n.yaml` at the project root.
