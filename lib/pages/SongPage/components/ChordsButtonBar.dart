import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/pages/SongPage/SongPage.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/ChordsByInstrument.dart';

class ChordsButtonBar extends StatelessWidget {
  final int transpose;
  final ChordNotation chordNotation;
  final void Function(ChordNotation) onSelectedChordNotation;
  final void Function() onIncreaseTranspose;
  final void Function() onDecreaseTranspose;
  final void Function(Instrument instrument) onOpenChordsByInstrument;

  const ChordsButtonBar({
    super.key,
    required this.transpose,
    required this.chordNotation,
    required this.onSelectedChordNotation,
    required this.onIncreaseTranspose,
    required this.onDecreaseTranspose,
    required this.onOpenChordsByInstrument,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${localizations.chordNotation}: ',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => onSelectedChordNotation(ChordNotation.Solfege),
                icon: Text(
                  'Do',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    decoration: chordNotation == ChordNotation.Solfege ? TextDecoration.underline : TextDecoration.none,
                    decorationColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Text('/'),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => onSelectedChordNotation(ChordNotation.Letter),
                icon: Text(
                  'C',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    decoration: chordNotation == ChordNotation.Letter ? TextDecoration.underline : TextDecoration.none,
                    decorationColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${localizations.transpose}: ',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              // Expanded(child: Container()),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onDecreaseTranspose,
                icon: const FaIcon(
                  FontAwesomeIcons.minus,
                  size: 16.0,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  transpose.toString(),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onIncreaseTranspose,
                icon: const FaIcon(
                  FontAwesomeIcons.plus,
                  size: 16.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 35.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Center(
                  child: Text(
                    '${localizations.chordsByInstrument}: ',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => onOpenChordsByInstrument(Instrument.guitar),
                  icon: Text(
                    localizations.guitar,
                    style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                  ),
                ),
                // IconButton(
                //   visualDensity: VisualDensity.compact,
                //   onPressed: () => onOpenChordsByInstrument(Instrument.piano),
                //   icon: Text(
                //     localizations.piano,
                //     style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                //   ),
                // ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => onOpenChordsByInstrument(Instrument.ukulele),
                  icon: Text(
                    localizations.ukulele,
                    style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
