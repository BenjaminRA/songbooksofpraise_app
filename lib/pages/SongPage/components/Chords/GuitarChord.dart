import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/ChordsByInstrument.dart';

class GuitarChordRenderer extends StatelessWidget {
  final GuitarChord chord;
  const GuitarChordRenderer({super.key, required this.chord});

  @override
  Widget build(BuildContext context) {
    final double width = double.infinity;
    final double height = 170.0;

    return SizedBox(
      width: width,
      height: height,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chord.positions.length,
        itemBuilder: (context, index) {
          final positions = chord.positions[index];
          final fingerings = chord.fingerings[index];

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomPaint(
              size: Size(width, height),
              painter: GuitarChordPainter(
                positions: positions,
                fingerings: fingerings,
              ),
            ),
          );
        },
      ),
    );
  }
}

class GuitarChordPainter extends CustomPainter {
  final List<int> positions;
  final List<int> fingerings;
  final int numStrings = 6;
  final int numFrets = 4;

  GuitarChordPainter({
    required this.positions,
    required this.fingerings,
  });

  int _getStartingFret() {
    // Find the minimum fret position (excluding -1 and 0)
    final validPositions = positions.where((p) => p > 0).toList();
    if (validPositions.isEmpty) return 1;

    final maxFret = validPositions.reduce((a, b) => a > b ? a : b);
    return maxFret <= numFrets ? 1 : validPositions.reduce((a, b) => a < b ? a : b);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scale = (size.width / 200).clamp(0.5, 2.0);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2 * scale
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final startingFret = _getStartingFret();
    final double leftMargin = 30 * scale; // Space for fret numbers
    final double topMargin = 30 * scale;
    final double bottomMargin = 30 * scale;
    final double diagramWidth = size.width - leftMargin - 20;
    final double diagramHeight = size.height - topMargin - bottomMargin;

    final double stringSpacing = diagramWidth / (numStrings - 1);
    final double fretSpacing = diagramHeight / numFrets;

    // Draw strings (vertical lines)
    for (int i = 0; i < numStrings; i++) {
      final x = leftMargin + (i * stringSpacing);
      canvas.drawLine(
        Offset(x, topMargin),
        Offset(x, topMargin + (numFrets * fretSpacing)),
        paint,
      );
    }

    // Draw frets (horizontal lines) and fret numbers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i <= numFrets; i++) {
      final y = topMargin + (i * fretSpacing);
      final isNut = (i == 0 && startingFret == 1);

      canvas.drawLine(
        Offset(leftMargin, y),
        Offset(leftMargin + diagramWidth, y),
        paint..strokeWidth = isNut ? 4 * scale : 2 * scale,
      );
      paint.strokeWidth = 2 * scale; // Reset

      // Draw fret numbers on the left (between frets)
      if (i < numFrets) {
        final fretNumber = startingFret + i;
        textPainter.text = TextSpan(
          text: fretNumber.toString(),
          style: TextStyle(
            fontSize: 12 * scale,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            (leftMargin - 10 - textPainter.width) / 2,
            y + (fretSpacing / 2) - (textPainter.height / 2),
          ),
        );
      }
    }

    // Draw top markers (X or O)
    for (int i = 0; i < positions.length && i < numStrings; i++) {
      final x = leftMargin + (i * stringSpacing);
      final position = positions[i];

      if (position == -1) {
        // Draw X for muted string
        textPainter.text = TextSpan(
          text: '✕',
          style: TextStyle(
            fontSize: 20 * scale,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (position == 0) {
        // Draw O for open string
        textPainter.text = TextSpan(
          text: '○',
          style: TextStyle(
            fontSize: 20 * scale,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        continue;
      }

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, 0),
      );
    }

    // Draw finger positions (black dots)
    for (int i = 0; i < positions.length && i < numStrings; i++) {
      final position = positions[i];
      if (position > 0) {
        final x = leftMargin + (i * stringSpacing);
        // Calculate relative position within the 4-fret window
        final relativeFret = position - startingFret + 1;
        final y = topMargin + (relativeFret * fretSpacing) - (fretSpacing / 2);

        // Draw black dot
        canvas.drawCircle(
          Offset(x, y),
          12 * scale,
          dotPaint,
        );
      }
    }

    // Draw finger numbers below the diagram
    final double bottomY = topMargin + (numFrets * fretSpacing) + 10 * scale;
    for (int i = 0; i < fingerings.length && i < numStrings; i++) {
      final fingering = fingerings[i];
      if (fingering > 0) {
        final x = leftMargin + (i * stringSpacing);

        textPainter.text = TextSpan(
          text: fingering.toString(),
          style: TextStyle(
            fontSize: 14 * scale,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, bottomY),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
