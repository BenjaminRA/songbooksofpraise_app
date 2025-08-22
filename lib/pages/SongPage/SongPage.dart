import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/components/SongLyrics.dart';
import 'package:songbooksofpraise_app/models/Song.dart';

class SongPage extends StatefulWidget {
  final Song song;
  const SongPage({super.key, required this.song});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  double getFontSize() {
    double width = MediaQuery.of(context).size.width;
    int longestLine = widget.song.lyrics.split('\n').map((line) => line.length).reduce((a, b) => a > b ? a : b);

    return MediaQuery.of(context).textScaler.scale(width * 0.061 - longestLine * 0.22);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SongLyrics(
            song: widget.song,
            fontSize: getFontSize(),
            showChords: true,
          )
        ],
      ),
    );
  }
}
