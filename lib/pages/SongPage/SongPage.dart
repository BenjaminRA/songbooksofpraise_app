import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/Providers/SettingsProvider.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/SongLyrics.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/FontAdjustmentButtonBar.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/SongPageToolbarChip.dart';

class SongPage extends StatefulWidget {
  final Song song;
  const SongPage({super.key, required this.song});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  late double fontSize = getInitialFontSize();
  late bool showChords = getInitialShowChords();
  bool showSheet = false;
  bool showTools = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAppBarActions();
    });
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
    double width = MediaQuery.of(context).size.width;
    int longestLine = widget.song.lyrics.split('\n').map((line) => line.length).reduce((a, b) => a > b ? a : b);

    return MediaQuery.of(context).textScaler.scale(width * 0.061 - longestLine * 0.22);
  }

  bool getInitialShowChords() {
    return Provider.of<SettingsProvider>(context, listen: false).showChordsByDefault;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    double toolbarHeight = 60.0;

    return Scaffold(
      body: ListView(
        // padding: const EdgeInsets.all(16.0),
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastEaseInToSlowEaseOut,
            height: showTools ? toolbarHeight : 0.0,
            transform: Transform.translate(offset: Offset(0, showTools ? 0 : -toolbarHeight)).transform,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  spacing: 6.0,
                  children: [
                    SongPageToolbarChip(
                      label: localizations.chords,
                      icon: FontAwesomeIcons.music,
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
                      selected: showSheet,
                      onSelected: () {
                        setState(() {
                          showSheet = !showSheet;
                        });
                      },
                    ),
                    Spacer(),
                    FontAdjustmentButtonBar(
                      actualFontSize: fontSize,
                      onIncreaseFontSize: () => setState(() => fontSize = fontSize + 1),
                      onDecreaseFontSize: () => setState(() => fontSize = fontSize - 1),
                    )
                  ],
                ),
              ],
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
