import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/SettingsProvider.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SettingsTab/components/SettingsRow.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';

class MusicAndAudioSection extends StatefulWidget {
  const MusicAndAudioSection({super.key});

  @override
  State<MusicAndAudioSection> createState() => _MusicAndAudioSectionState();
}

class _MusicAndAudioSectionState extends State<MusicAndAudioSection> {
  bool showChordsByDefault = false;
  int defaultTranspose = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showChordsByDefault = Provider.of<SettingsProvider>(context).showChordsByDefault;
    defaultTranspose = Provider.of<SettingsProvider>(context).defaultTranspose;
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
              title: localizations.defaultTranspose,
              description: localizations.automaticKeyAdjustment,
              action: DropdownMenu<int>(
                onSelected: (value) {
                  if (value == null) return;

                  Provider.of<SettingsProvider>(context, listen: false).setDefaultTranspose(value);
                  setState(() {
                    defaultTranspose = value;
                  });
                },
                initialSelection: defaultTranspose,
                enableSearch: false,
                dropdownMenuEntries: List.generate(
                  23,
                  (index) {
                    final value = (index - 11);
                    return DropdownMenuEntry(value: value, label: value.toString());
                  },
                ),
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
          ],
        ),
      ),
    );
  }
}
