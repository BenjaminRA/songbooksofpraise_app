import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/Chords/GuitarChord.dart';
import 'package:songbooksofpraise_app/pages/SongPage/components/Chords/UkuleleChord.dart';

class Chord {
  final String name;

  Chord({required this.name});
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

enum Instrument {
  guitar,
  piano,
  ukulele,
}

class ChordsByInstrument extends StatefulWidget {
  final Song song;
  final Instrument instrument;
  final ChordNotation chordNotation;

  const ChordsByInstrument({super.key, required this.song, required this.instrument, required this.chordNotation});

  @override
  State<ChordsByInstrument> createState() => _ChordsByInstrumentState();
}

class _ChordsByInstrumentState extends State<ChordsByInstrument> {
  bool loading = true;
  List<Chord> chords = [];

  @override
  void initState() {
    super.initState();

    initChords();
  }

  String decompressGzip(ByteData data) {
    final List<int> decompressedData = gzip.decode(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    final String originalData = utf8.decode(decompressedData);
    return originalData;
  }

  dynamic fetchChordsData() async {
    ByteData rawData;

    AssetBundle bundle = DefaultAssetBundle.of(context);
    rawData = await bundle.load('assets/chords/${widget.instrument.name}.json.gz');
    String jsonString = decompressGzip(rawData);

    return jsonDecode(jsonString);
  }

  void initChords() async {
    dynamic chordsData = await fetchChordsData();

    List<Chord> loadedChords = [];

    List<Chord> songChords = widget.song.getChordsInLyrics(ChordNotation.Letter);

    for (Chord songChord in songChords) {
      if (chordsData.containsKey(songChord.name)) {
        dynamic chordInfo = chordsData[songChord.name];

        switch (widget.instrument) {
          case Instrument.guitar:
            loadedChords.add(GuitarChord(
              name: songChord.name,
              positions: List<List<int>>.from(chordInfo.map((chord) => List<int>.from(chord['positions'].map((e) => int.parse(e))))),
              fingerings: List<List<int>>.from(chordInfo.map((chord) => List<int>.from(chord['fingerings'][0].map((e) => int.parse(e))))),
            ));
            break;
          case Instrument.ukulele:
            loadedChords.add(UkuleleChord(
              name: songChord.name,
              positions: List<List<int>>.from(chordInfo.map((chord) => List<int>.from(chord['positions'].map((e) => int.parse(e))))),
              fingerings: List<List<int>>.from(chordInfo.map((chord) => List<int>.from(chord['fingerings'][0].map((e) => int.parse(e))))),
            ));
            break;
          case Instrument.piano:
            loadedChords.add(PianoChord(
              name: songChord.name,
              keys: List<String>.from(chordInfo['keys']),
            ));
            break;
        }
      }
    }

    setState(() {
      chords = loadedChords;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    if (loading) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: SpinKitThreeBounce(
            color: Theme.of(context).primaryColor,
            size: 50.0,
          ),
        ),
      );
    }

    String instrumentName;
    switch (widget.instrument) {
      case Instrument.guitar:
        instrumentName = localizations.guitar;
        break;
      case Instrument.piano:
        instrumentName = localizations.piano;
        break;
      case Instrument.ukulele:
        instrumentName = localizations.ukulele;
        break;
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            SliverToBoxAdapter(
              child: Text(
                '$instrumentName ${localizations.chords}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 4 / 5,
                maxCrossAxisExtent: 250,
                // mainAxisSpacing: 32.0,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                Chord chord = chords[index];
                return Card(
                  elevation: 1.0,
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Chord name
                        Text(
                          chord.name,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        // Chord diagram
                        if (chord is GuitarChord)
                          GuitarChordRenderer(
                            chord: chord,
                            // scale: 0.65,
                          ),
                        if (chord is UkuleleChord)
                          UkuleleChordRenderer(
                            chord: chord,
                            // scale: 0.65,
                          ),
                      ],
                    ),
                  ),
                );
              }, childCount: chords.length),
            ),
          ],
        ),
      ),
    );
  }
}
