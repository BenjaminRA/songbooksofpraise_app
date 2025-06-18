import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SettingsTab/components/SettingsRow.dart';

class MusicAndAudioSection extends StatefulWidget {
  const MusicAndAudioSection({super.key});

  @override
  State<MusicAndAudioSection> createState() => _MusicAndAudioSectionState();
}

class _MusicAndAudioSectionState extends State<MusicAndAudioSection> {
  bool showChordsByDefault = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Text(
              'Music & Audio',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SettingsRow(
              title: 'Default Transpose',
              description: 'Automatic Key Adjustment',
              action: DropdownMenu(
                initialSelection: '0',
                enableSearch: false,
                dropdownMenuEntries: List.generate(
                  23,
                  (index) {
                    final value = (index - 11).toString();
                    return DropdownMenuEntry(value: value, label: value);
                  },
                ),
              ),
            ),
            SettingsRow(
              title: 'Show Chords by Default',
              description: 'Display chords when opening songs',
              action: Switch(
                value: showChordsByDefault,
                onChanged: (value) => setState(() => showChordsByDefault = value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
