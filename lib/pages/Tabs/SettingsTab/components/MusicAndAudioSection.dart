import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/SettingsProvider.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SettingsTab/components/SettingsRow.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';

class MusicAndAudioSection extends StatefulWidget {
  const MusicAndAudioSection({super.key});

  @override
  State<MusicAndAudioSection> createState() => _MusicAndAudioSectionState();
}

class _MusicAndAudioSectionState extends State<MusicAndAudioSection> {
  bool showChordsByDefault = false;
  bool showSheetByDefault = false;
  ChordNotation defaultNotation = ChordNotation.Letter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showChordsByDefault = Provider.of<SettingsProvider>(context).showChordsByDefault;
    showSheetByDefault = Provider.of<SettingsProvider>(context).showSheetByDefault;
    defaultNotation = Provider.of<SettingsProvider>(context).defaultNotation;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Text(
              localizations.musicAndAudio,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SettingsRow(
              title: localizations.defaultNotation,
              description: localizations.defaultNotationHelperText,
              action: DropdownMenu<ChordNotation>(
                onSelected: (value) {
                  if (value == null) return;

                  Provider.of<SettingsProvider>(context, listen: false).setDefaultNotation(value);
                  setState(() {
                    defaultNotation = value;
                  });
                },
                initialSelection: defaultNotation,
                enableSearch: false,
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: ChordNotation.Letter, label: localizations.letterNotation),
                  DropdownMenuEntry(value: ChordNotation.Solfege, label: localizations.solfegeNotation),
                ],
              ),
            ),
            SettingsRow(
              title: localizations.showChordsByDefault,
              description: localizations.displayChordsWhenOpeningSongs,
              action: Switch(
                value: showChordsByDefault,
                onChanged: (value) {
                  setState(() {
                    showChordsByDefault = value;
                  });
                  Provider.of<SettingsProvider>(context, listen: false).setShowChordsByDefault(value);
                },
              ),
            ),
            SettingsRow(
              title: localizations.showSheetByDefault,
              description: localizations.displaySheetMusicWhenOpeningSongs,
              action: Switch(
                value: showSheetByDefault,
                onChanged: (value) {
                  setState(() {
                    showSheetByDefault = value;
                  });
                  Provider.of<SettingsProvider>(context, listen: false).setShowSheetByDefault(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
