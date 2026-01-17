import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/Providers/SettingsProvider.dart';
import 'package:songbooksofpraise_app/db/DB.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/ChordsButtonBar.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/ChordsByInstrument.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/SongLyrics.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/FontAdjustmentButtonBar.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/SongPageToolbarChip.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/MusicSheetViewer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SongPage extends StatefulWidget {
  final Song song;
  const SongPage({super.key, required this.song});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  late double fontSize = getInitialFontSize();
  late bool showChords = getInitialShowChords();
  bool showTools = false;
  ChordNotation chordNotation = ChordNotation.Letter;

  @override
  void initState() {
    super.initState();

    widget.song.transposeChords(widget.song.transpose, chordNotation);

    registerRecentlyPlayedSong();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAppBarActions();

      Provider.of<SettingsProvider>(context, listen: false).keepScreenOn ? WakelockPlus.enable() : WakelockPlus.disable();

      setState(() {
        chordNotation = Provider.of<SettingsProvider>(context, listen: false).defaultNotation;
        widget.song.transposeChords(widget.song.transpose, chordNotation);
      });

      checkShowSheetByDefault();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WakelockPlus.disable();
  }

  void registerRecentlyPlayedSong() async {
    DB.rawInsert('''
      INSERT INTO recently_played_songs (song_id, played_at)
      VALUES (?, CURRENT_TIMESTAMP);
    ''', arguments: [widget.song.id]);
  }

  void _updateAppBarActions() {
    Provider.of<AppBarProvider>(context, listen: false).setActions([
      IconButton(
        icon: Icon(
          showTools ? Icons.close : Icons.tune,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        onPressed: () {
          setState(() {
            showTools = !showTools;
          });
          _updateAppBarActions();
        },
      ),
    ]);
  }

  double getInitialFontSize() {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.of(context).textScaler.scale(1.0);

    // Account for horizontal padding (16.0 on each side from ListView padding)
    final availableWidth = screenWidth - 32.0;

    // Find the longest line in the lyrics
    final lines = widget.song.lyrics.split('\n');
    if (lines.isEmpty) return 16.0; // Default fallback

    final longestLineLength = lines.map((line) => line.trim().length).reduce((a, b) => a > b ? a : b);

    if (longestLineLength == 0) return 16.0; // Default fallback

    // Set reasonable bounds for font size
    const minFontSize = 12.0;
    const maxFontSize = 20.0;

    // Average character width is approximately 0.55 * fontSize for most fonts
    // This accounts for variable-width fonts and typical character distributions
    const avgCharWidthRatio = 0.55;

    // Calculate ideal font size to fit the longest line
    // Formula: availableWidth = longestLineLength * (fontSize * avgCharWidthRatio * textScaleFactor)
    double idealFontSize = availableWidth / (longestLineLength * avgCharWidthRatio * textScaleFactor);

    // Clamp the font size within reasonable bounds
    double fontSize = idealFontSize.clamp(minFontSize, maxFontSize);

    return fontSize;
  }

  bool getInitialShowChords() {
    return Provider.of<SettingsProvider>(context, listen: false).showChordsByDefault;
  }

  void checkShowSheetByDefault() {
    if (Provider.of<SettingsProvider>(context, listen: false).showSheetByDefault) {
      openSheet();
    }
  }

  void openChordsByInstrument(Instrument instrument) async {
    AppBarProvider appBarProvider = Provider.of<AppBarProvider>(context, listen: false);

    appBarProvider.setTitle(appBarProvider.state.copyWith(
      actions: [],
    ));

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChordsByInstrument(
          song: widget.song,
          instrument: instrument,
          chordNotation: chordNotation,
        ),
      ),
    );

    _updateAppBarActions();
  }

  void openSheet() async {
    AppBarProvider appBarProvider = Provider.of<AppBarProvider>(context, listen: false);

    appBarProvider.setTitle(appBarProvider.state.copyWith(
      actions: [],
    ));

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicSheetViewer(
          imageUrl: widget.song.music_sheet!,
        ),
      ),
    );

    _updateAppBarActions();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    double chordsToolsHeight = (showChords && widget.song.hasChordsInLyrics()) ? 130.0 : 0.0;
    double toolbarHeight = 105.0 + chordsToolsHeight;

    List<Widget> toolbarChildren = [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          spacing: 12.0,
          children: [
            SongPageToolbarChip(
              label: localizations.chords,
              icon: FontAwesomeIcons.music,
              disabled: !widget.song.hasChordsInLyrics(),
              selected: showChords,
              onSelected: () {
                setState(() {
                  showChords = !showChords;
                });
              },
            ),
            SongPageToolbarChip(
              label: localizations.sheet,
              icon: FontAwesomeIcons.fileLines,
              selected: false,
              disabled: widget.song.music_sheet == null,
              onSelected: openSheet,
            ),
            Spacer(),
          ],
        ),
      ),
    ];

    if (showChords && widget.song.hasChordsInLyrics()) {
      toolbarChildren.addAll([
        Divider(height: 0.0),
        ChordsButtonBar(
          transpose: widget.song.transpose,
          chordNotation: chordNotation,
          onOpenChordsByInstrument: (instrument) => openChordsByInstrument(instrument),
          onSelectedChordNotation: (notation) => setState(() {
            chordNotation = notation;
            widget.song.transposeChords(widget.song.transpose, chordNotation);
          }),
          onIncreaseTranspose: () => setState(() {
            widget.song.transpose = widget.song.transpose + 1;
            widget.song.transposeChords(widget.song.transpose, chordNotation);
          }),
          onDecreaseTranspose: () => setState(() {
            widget.song.transpose = widget.song.transpose - 1;
            widget.song.transposeChords(widget.song.transpose, chordNotation);
          }),
        ),
      ]);
    }

    toolbarChildren.addAll([
      Divider(height: 0.0),
      FontAdjustmentButtonBar(
        actualFontSize: fontSize,
        onIncreaseFontSize: () => setState(() => fontSize = fontSize + 1),
        onDecreaseFontSize: () => setState(() => fontSize = fontSize - 1),
      )
    ]);

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        // padding: const EdgeInsets.all(16.0),
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastEaseInToSlowEaseOut,
            height: showTools ? toolbarHeight : 0.0,
            transform: Transform.translate(offset: Offset(0, showTools ? 0 : -toolbarHeight)).transform,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: toolbarChildren,
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(16.0),
            child: SongLyrics(
              song: widget.song,
              fontSize: fontSize,
              showChords: showChords,
            ),
          ),
        ],
      ),
    );
  }
}
