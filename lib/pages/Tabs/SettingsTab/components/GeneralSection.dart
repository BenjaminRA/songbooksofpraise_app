import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/SettingsProvider.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SettingsTab/components/SettingsRow.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';

class GeneralSection extends StatefulWidget {
  const GeneralSection({super.key});

  @override
  State<GeneralSection> createState() => _GeneralSectionState();
}

class _GeneralSectionState extends State<GeneralSection> {
  bool autoSongbooksUpdate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    autoSongbooksUpdate = Provider.of<SettingsProvider>(context).autoSongbooksUpdate;
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
              localizations.general,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SettingsRow(
              title: localizations.autoSongbooksUpdate,
              description: localizations.enableAutoSongbooksUpdate,
              spacing: 2.0,
              action: Switch(
                value: autoSongbooksUpdate,
                onChanged: (value) {
                  setState(() {
                    autoSongbooksUpdate = value;
                  });
                  Provider.of<SettingsProvider>(context, listen: false).setAutoSongbooksUpdate(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
