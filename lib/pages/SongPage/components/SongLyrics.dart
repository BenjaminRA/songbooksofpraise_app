import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Song.dart';

class _LyricsText {
  final String text;
  final bool bold;
  final bool italic;

  const _LyricsText(this.text, {this.bold = false, this.italic = false});
}

class _ChordPosition {
  final String chord;
  final int textOffset;

  const _ChordPosition(this.chord, this.textOffset);
}

class _ParsedLyricsLine {
  final List<_LyricsText> text;
  final List<_ChordPosition> chords;

  const _ParsedLyricsLine(this.text, this.chords);
}

_ParsedLyricsLine _parseLyricsLine(String line, bool showChords) {
  final text = <_LyricsText>[];
  final chords = <_ChordPosition>[];
  var textLength = 0;

  void appendText(String value, bool bold, bool italic) {
    if (value.isEmpty) return;
    text.add(_LyricsText(value, bold: bold, italic: italic));
    textLength += value.length;
  }

  int parseRange(int start, int end, bool bold, bool italic) {
    var cursor = start;

    while (cursor < end) {
      final chordEnd = line.indexOf(']', cursor);
      if (line.startsWith('[', cursor) && chordEnd > cursor + 1 && chordEnd < end) {
        if (showChords) {
          chords.add(_ChordPosition(line.substring(cursor + 1, chordEnd), textLength));
        }
        cursor = chordEnd + 1;
        continue;
      }

      final marker = line.startsWith('**', cursor)
          ? '**'
          : line.startsWith('%%', cursor)
              ? '%%'
              : line.startsWith('||', cursor)
                  ? '||'
                  : line.startsWith('*', cursor)
                      ? '*'
                      : null;

      if (marker != null) {
        final markerEnd = line.indexOf(marker, cursor + marker.length);
        if (markerEnd != -1 && markerEnd < end) {
          final contentVisible = marker == '**' || marker == '*' || (marker == '||' ? showChords : !showChords);

          if (contentVisible) {
            var contentStart = cursor + marker.length;
            var contentEnd = markerEnd;

            if (marker == '%%' || marker == '||') {
              while (contentStart < contentEnd && line[contentStart].trim().isEmpty) {
                contentStart++;
              }
              while (contentEnd > contentStart && line[contentEnd - 1].trim().isEmpty) {
                contentEnd--;
              }
            }

            parseRange(
              contentStart,
              contentEnd,
              bold || marker == '**',
              italic || marker == '*',
            );
          }
          cursor = markerEnd + marker.length;
          continue;
        }
      }

      var nextCursor = cursor + 1;
      while (nextCursor < end &&
          !line.startsWith('[', nextCursor) &&
          !line.startsWith('*', nextCursor) &&
          !line.startsWith('%', nextCursor) &&
          !line.startsWith('|', nextCursor)) {
        nextCursor++;
      }
      appendText(line.substring(cursor, nextCursor), bold, italic);
      cursor = nextCursor;
    }

    return cursor;
  }

  parseRange(0, line.length, false, false);
  return _ParsedLyricsLine(text, chords);
}

bool _isStructureLine(String line) {
  return RegExp(r'^(verse|chorus|refrain|bridge)(( \d+)*)', caseSensitive: false).hasMatch(line);
}

bool _hasVisibleContent(String line, bool showChords) {
  if (_isStructureLine(line)) return true;

  final parsedLine = _parseLyricsLine(line, showChords);
  return parsedLine.text.any((part) => part.text.trim().isNotEmpty) || parsedLine.chords.isNotEmpty;
}

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
    AppLocalizations localizations = AppLocalizations.of(context)!;

    List<Widget> lyricsParagraphs = [];

    // Split lyrics into paragraphs based on double newlines
    for (var paragraphs in song.transposedLyrics.split('\n\n')) {
      List<InlineSpan> lyricsSpans = [];
      bool isChorus = false;

      // Split paragraphs into lines
      final lines = paragraphs.split('\n').map((line) => line.trim()).where((line) => _hasVisibleContent(line, showChords)).toList();
      for (int i = 0; i < lines.length; i++) {
        bool lastLine = i == lines.length - 1;
        String line = lines[i];

        // Check if the line is a structure line (verse, chorus, refrain bridge)
        if (_isStructureLine(line)) {
          isChorus = line.toLowerCase().contains('chorus');

          String structureLine = line.toUpperCase().split(' ')[0];
          String translatedStructureLine = '';
          if (structureLine == 'VERSE') {
            translatedStructureLine = localizations.verse + line.substring(5); // Add verse number if present
          } else if (structureLine == 'CHORUS') {
            translatedStructureLine = localizations.chorus + line.substring(6); // Add chorus number if present
          } else if (structureLine == 'BRIDGE') {
            translatedStructureLine = localizations.bridge + line.substring(6); // Add bridge number if present
          } else if (structureLine == 'REFRAIN') {
            translatedStructureLine = localizations.refrain + line.substring(7); // Add refrain number if present
          }

          // Structure line
          lyricsSpans.add(TextSpan(
            text: '${translatedStructureLine.toUpperCase()}${lastLine ? '' : '\n'}',
            style: TextStyle(
              fontSize: fontSize,
              color: Theme.of(context).primaryColor,
            ),
          ));
        } else {
          final parsedLine = _parseLyricsLine(line, showChords);
          final lyricsLine = parsedLine.text.map((part) => part.text).join();
          var lastChordOffset = 0;

          // To match the chords with the lyrics we print the lyrics but make them transparent
          if (showChords && parsedLine.chords.isNotEmpty) {
            // If chords are to be shown, format the line with chords
            for (final chord in parsedLine.chords) {
              // The lyrics between the chords
              if (chord.textOffset > lastChordOffset) {
                lyricsSpans.add(
                  TextSpan(
                    text: lyricsLine.substring(lastChordOffset, chord.textOffset),
                    style: const TextStyle(
                      color: Colors.transparent,
                    ),
                  ),
                );
              }
              lastChordOffset = chord.textOffset;

              // Add the chord
              lyricsSpans.add(
                TextSpan(
                  text: '${chord.chord[0].toUpperCase()}${chord.chord.substring(1)}',
                  style: TextStyle(
                    fontSize: fontSize * 0.9,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }

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
          for (final part in parsedLine.text) {
            lyricsSpans.add(
              TextSpan(
                text: part.text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: part.bold ? FontWeight.bold : null,
                  fontStyle: part.italic ? FontStyle.italic : null,
                ),
              ),
            );
          }
          if (!lastLine) {
            lyricsSpans.add(TextSpan(text: '\n', style: TextStyle(fontSize: fontSize)));
          }
        }
      }

      if (lyricsSpans.isEmpty) continue;

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

    // for (var line in song.transposedLyrics.split('\n')) {
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
