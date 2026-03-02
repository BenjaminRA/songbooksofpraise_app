import 'package:songbooksofpraise_app/models/Song.dart';

class Chord {
  String name;
  late ChordNotation notation;

  Chord({required this.name}) {
    notation = _getChordNotation();
  }

  ChordNotation _getChordNotation() {
    final solfegePattern = RegExp(r'\b(do|re|mi|fa|sol|la|si)', caseSensitive: false);

    final hasSolfegeChords = solfegePattern.hasMatch(name);

    if (hasSolfegeChords) {
      return ChordNotation.Solfege;
    }

    return ChordNotation.Letter;
  }

  void transposeChord(int semitones, [ChordNotation? outputNotation]) {
    outputNotation ??= notation;

    const List<String> letterChordsSharp = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    const List<String> letterChordsFlat = ['C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B'];

    const List<String> solfegeChordsSharp = ['Do', 'Do#', 'Re', 'Re#', 'Mi', 'Fa', 'Fa#', 'Sol', 'Sol#', 'La', 'La#', 'Si'];
    const List<String> solfegeChordsFlat = ['Do', 'Reb', 'Re', 'Mib', 'Mi', 'Fa', 'Solb', 'Sol', 'Lab', 'La', 'Sib', 'Si'];

    List<String> originalChordNotationList = notation == ChordNotation.Letter ? letterChordsSharp : solfegeChordsSharp;
    List<String> finalChordNotationList = outputNotation == ChordNotation.Letter ? letterChordsSharp : solfegeChordsSharp;

    String baseChord = name.toUpperCase();

    int chordListIndex = originalChordNotationList.indexWhere((c) {
      // If is not a sharp chord but the base chord contains a sharp version, skip it
      if (!c.contains('#') && baseChord.contains('${c.toUpperCase()}#')) {
        return false;
      }

      // If is flat
      if (!c.contains('b') && baseChord.contains('${c.toUpperCase()}B')) {
        return false;
      }

      return baseChord.startsWith(c.toUpperCase());
    });

    if (chordListIndex == -1) {
      originalChordNotationList = notation == ChordNotation.Letter ? letterChordsFlat : solfegeChordsFlat;
      finalChordNotationList = outputNotation == ChordNotation.Letter ? letterChordsFlat : solfegeChordsFlat;

      chordListIndex = originalChordNotationList.indexWhere((c) => baseChord.startsWith(c.toUpperCase()));
    }

    name = name.toLowerCase().replaceAll(
          originalChordNotationList[chordListIndex].toLowerCase(),
          finalChordNotationList[(chordListIndex + semitones) % finalChordNotationList.length],
        );
  }
}

class GuitarChord extends Chord {
  final List<List<int>> positions;
  final List<List<int>> fingerings;

  GuitarChord({required String name, required this.positions, required this.fingerings}) : super(name: name);
}

class UkuleleChord extends Chord {
  final List<List<int>> positions;
  final List<List<int>> fingerings;

  UkuleleChord({required String name, required this.positions, required this.fingerings}) : super(name: name);
}

class PianoChord extends Chord {
  final List<String> keys;

  PianoChord({required String name, required this.keys}) : super(name: name);
}
