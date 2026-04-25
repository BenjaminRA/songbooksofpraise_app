import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/models/Chord.dart';

class PianoChordRenderer extends StatelessWidget {
  final PianoChord chord;
  const PianoChordRenderer({super.key, required this.chord});

  @override
  Widget build(BuildContext context) {
    final double width = double.infinity;
    final double height = 170.0;

    return SizedBox(
      width: width,
      height: height,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chord.keys.length,
        itemBuilder: (context, index) {
          final notes = chord.keys[index];

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomPaint(
              size: Size(width, height),
              painter: PianoChordPainter(
                notes: notes,
                primaryColor: Theme.of(context).primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PianoChordPainter extends CustomPainter {
  final List<String> notes;
  final Color primaryColor;

  PianoChordPainter({required this.notes, required this.primaryColor});

  static const _whiteNotes = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  static const _sharpNotes = ['C#', 'D#', 'F#', 'G#', 'A#'];
  static const _flatNotes = ['Db', 'Eb', 'Gb', 'Ab', 'Bb'];

  // Center X offsets of black keys as multiples of whiteKeyWidth from the
  // start of the octave: C# ≈ 2/3, D# ≈ 5/3, F# ≈ 11/3, G# ≈ 14/3, A# ≈ 17/3
  static const _blackKeyOffsets = [0.667, 1.667, 3.667, 4.667, 5.667];

  /// Parses a note string like "C#3" → ("C#", 3). Returns null on failure.
  static (String, int)? _parseNote(String raw) {
    final match = RegExp(r'^([A-Ga-g][#b]?)(\d+)$').firstMatch(raw);
    if (match == null) return null;
    final notePart = match.group(1)!;
    final normalized = notePart[0].toUpperCase() + (notePart.length > 1 ? notePart[1] : '');
    return (normalized, int.parse(match.group(2)!));
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (notes.isEmpty) return;

    // Parse all notes
    final parsed = notes.map(_parseNote).whereType<(String, int)>().toList();
    if (parsed.isEmpty) return;

    final octaves = parsed.map((p) => p.$2).toList();
    final minOctave = octaves.reduce((a, b) => a < b ? a : b);
    final maxOctave = minOctave + 1; // always show exactly 2 octaves
    final numOctaves = 2;

    final whiteKeyWidth = size.width / (numOctaves * 7);
    final whiteKeyHeight = size.height;
    final blackKeyWidth = whiteKeyWidth * 0.65;
    final blackKeyHeight = whiteKeyHeight * 0.62;

    // Build active note lookup: "C#3", "D4", etc.
    final activeSet = <String>{};
    for (final p in parsed) {
      activeSet.add('${p.$1}${p.$2}');
    }

    bool isActive(String name, int octave) => activeSet.contains('$name$octave');

    final whiteFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final blackFill = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final activeWhiteFill = Paint()
      ..color = primaryColor.withAlpha(200)
      ..style = PaintingStyle.fill;
    final activeBlackFill = Paint()
      ..color = primaryColor.withAlpha(220)
      ..style = PaintingStyle.fill;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // ── White keys ────────────────────────────────────────────────────────────
    for (int oct = minOctave; oct <= maxOctave; oct++) {
      final octStartX = (oct - minOctave) * 7 * whiteKeyWidth;

      for (int k = 0; k < 7; k++) {
        final x = octStartX + k * whiteKeyWidth;
        final active = isActive(_whiteNotes[k], oct);

        final rect = RRect.fromRectAndCorners(
          Rect.fromLTWH(x + 0.5, 0.5, whiteKeyWidth - 1, whiteKeyHeight - 1),
          bottomLeft: const Radius.circular(3),
          bottomRight: const Radius.circular(3),
        );

        canvas.drawRRect(rect, active ? activeWhiteFill : whiteFill);
        canvas.drawRRect(rect, border);

        // Note label at the bottom of every white key (when wide enough)
        if (whiteKeyWidth >= 12) {
          final fontSize = (whiteKeyWidth * 0.48).clamp(7.0, 13.0);
          textPainter.text = TextSpan(
            text: _whiteNotes[k],
            style: TextStyle(
              color: active ? Colors.white : Colors.black54,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );
          textPainter.layout(maxWidth: whiteKeyWidth);
          textPainter.paint(
            canvas,
            Offset(
              x + (whiteKeyWidth - textPainter.width) / 2,
              whiteKeyHeight - textPainter.height - 4,
            ),
          );
        }
      }
    }

    // ── Black keys ────────────────────────────────────────────────────────────
    for (int oct = minOctave; oct <= maxOctave; oct++) {
      final octStartX = (oct - minOctave) * 7 * whiteKeyWidth;

      for (int b = 0; b < _sharpNotes.length; b++) {
        final centerX = octStartX + _blackKeyOffsets[b] * whiteKeyWidth;
        final active = isActive(_sharpNotes[b], oct) || isActive(_flatNotes[b], oct);

        final rect = RRect.fromRectAndCorners(
          Rect.fromLTWH(centerX - blackKeyWidth / 2, 0, blackKeyWidth, blackKeyHeight),
          bottomLeft: const Radius.circular(3),
          bottomRight: const Radius.circular(3),
        );

        canvas.drawRRect(rect, active ? activeBlackFill : blackFill);

        // Note label at the bottom of every black key (when wide enough)
        if (blackKeyWidth >= 10) {
          final fontSize = (blackKeyWidth * 0.38).clamp(6.0, 10.0);
          textPainter.text = TextSpan(
            text: _sharpNotes[b],
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );
          textPainter.layout(maxWidth: blackKeyWidth);
          textPainter.paint(
            canvas,
            Offset(
              centerX - textPainter.width / 2,
              blackKeyHeight - textPainter.height - 3,
            ),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
