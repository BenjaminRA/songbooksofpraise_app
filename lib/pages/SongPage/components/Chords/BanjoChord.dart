import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/models/Chord.dart';

class BanjoChordRenderer extends StatelessWidget {
  final BanjoChord chord;
  const BanjoChordRenderer({super.key, required this.chord});

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
              painter: BanjoChordPainter(
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

class BanjoChordPainter extends CustomPainter {
  final List<int> positions;
  final List<int> fingerings;
  final int numStrings = 5;
  final int numFrets = 4;

  BanjoChordPainter({
    required this.positions,
    required this.fingerings,
  });

  int _getStartingFret() {
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
    final double leftMargin = 30 * scale;
    final double topMargin = 30 * scale;
    final double bottomMargin = 30 * scale;
    final double diagramWidth = size.width - leftMargin - 20;
    final double diagramHeight = size.height - topMargin - bottomMargin;

    final double stringSpacing = diagramWidth / (numStrings - 1);
    final double fretSpacing = diagramHeight / numFrets;

    for (int i = 0; i < numStrings; i++) {
      final x = leftMargin + (i * stringSpacing);
      canvas.drawLine(
        Offset(x, topMargin),
        Offset(x, topMargin + (numFrets * fretSpacing)),
        paint,
      );
    }

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
      paint.strokeWidth = 2 * scale;

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

    for (int i = 0; i < positions.length && i < numStrings; i++) {
      final x = leftMargin + (i * stringSpacing);
      final position = positions[i];

      if (position == -1) {
        textPainter.text = TextSpan(
          text: '✕',
          style: TextStyle(
            fontSize: 20 * scale,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (position == 0) {
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

    for (int i = 0; i < positions.length && i < numStrings; i++) {
      final position = positions[i];
      if (position > 0) {
        final x = leftMargin + (i * stringSpacing);
        final relativeFret = position - startingFret + 1;
        final y = topMargin + (relativeFret * fretSpacing) - (fretSpacing / 2);

        canvas.drawCircle(
          Offset(x, y),
          12 * scale,
          dotPaint,
        );
      }
    }

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
