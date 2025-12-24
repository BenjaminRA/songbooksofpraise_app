import 'dart:math';

import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/models/Song.dart';

class SongLyrics extends StatelessWidget {
  final Song song;
  final double fontSize;
  final bool showChords;

  const SongLyrics({
    super.key,
    required this.song,
    required this.fontSize,
    required this.showChords,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> lyricsParagraphs = [];

    // Split lyrics into paragraphs based on double newlines
    for (var paragraphs in song.lyrics.split('\n\n')) {
      List<InlineSpan> lyricsSpans = [];
      bool isChorus = false;

      // Split paragraphs into lines
      final lines = paragraphs.split('\n');
      for (int i = 0; i < lines.length; i++) {
        bool lastLine = i == lines.length - 1;
        String line = lines[i];
        line = line.trim();

        // Check if the line is a structure line (verse, chorus, bridge)
        if (RegExp(r'^(verse|chorus|bridge)(( \d+)*)', caseSensitive: false).hasMatch(line)) {
          isChorus = line.toLowerCase().contains('chorus');

          // Structure line
          lyricsSpans.add(TextSpan(
            text: '${line.toUpperCase()}\n',
            style: TextStyle(
              fontSize: fontSize,
              color: Theme.of(context).primaryColor,
            ),
          ));
        } else {
          final chordRegex = RegExp(r'\[([^\]]+)\]');
          String lyricsLine = line.replaceAll(chordRegex, '').trim();
          int lastChordEnd = 0;
          int lastChordSize = 0;

          // To match the chords with the lyrics we print the lyrics but make them transparent
          if (showChords) {
            // If chords are to be shown, format the line with chords
            for (var match in chordRegex.allMatches(line)) {
              lyricsSpans.add(
                TextSpan(
                  text: line.substring(
                    lastChordEnd,
                    max(0, match.start - 1 - lastChordSize), // In case the lyrics start with a chord
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.transparent,
                  ),
                ),
              );
              lastChordEnd = match.end;
              lastChordSize = match.group(0)!.length - 2; // Exclude the brackets

              lyricsSpans.add(
                TextSpan(
                  text: '${match.group(1)![0].toUpperCase()}${match.group(1)!.substring(1)}',
                  style: TextStyle(
                    fontSize: fontSize * 0.9,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }

            if (lastChordEnd > 0) {
              lyricsSpans.add(
                TextSpan(
                  text: '\n',
                  style: TextStyle(
                    fontSize: fontSize * 0.9,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }
          }
          lyricsSpans.add(
            TextSpan(
              text: '$lyricsLine${lastLine ? '' : '\n'}',
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          );
        }
      }

      Widget widget = RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          children: lyricsSpans,
        ),
      );

      lyricsParagraphs.add(
        isChorus
            ? Container(
                // width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 250, 231, 1.0),
                  border: Border.all(color: Color.fromRGBO(251, 232, 160, 1.0), width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: widget,
              )
            : Container(
                // width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: widget,
              ),
      );
    }

    //   paragraphs = paragraphs.trim();
    //   if (paragraphs.isNotEmpty) {
    //     lyricsParagraphs.add(
    //       Padding(
    //         padding: const EdgeInsets.only(bottom: 8.0),
    //         child: Text(
    //           paragraphs,
    //           style: TextStyle(fontSize: fontSize, height: 1.5),
    //         ),
    //       ),
    //     );
    //   }
    // }

    // for (var line in song.lyrics.split('\n')) {
    //   line = line.trim();

    //   // Structure line
    //   if (RegExp(r'(verse|chorus|bridge)(( \d+)*)', caseSensitive: false).hasMatch(line)) {
    //     lyricsSpans.add(TextSpan(
    //       text: line.toUpperCase() + '\n',
    //       style: TextStyle(
    //         fontSize: fontSize,
    //         // fontWeight: FontWeight.bold,
    //         color: Theme.of(context).primaryColor,
    //       ),
    //     ));
    //   } else {
    //     // Just lyrics without chords
    //     lyricsSpans.add(TextSpan(
    //       text: line + '\n',
    //       style: TextStyle(
    //         fontSize: fontSize,
    //       ),
    //     ));
    //   }
    // }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: lyricsParagraphs,
      ),
    );
  }
}
