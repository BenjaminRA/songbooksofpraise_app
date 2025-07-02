import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/SettingsProvider.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SettingsTab/components/SettingsRow.dart';

class DisplaySection extends StatefulWidget {
  const DisplaySection({super.key});

  @override
  State<DisplaySection> createState() => _DisplaySectionState();
}

class _DisplaySectionState extends State<DisplaySection> {
  String textSize = 'medium';
  String theme = 'light';
  bool keepScreenOn = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textSize = Provider.of<SettingsProvider>(context).textSize.name;
    theme = Provider.of<SettingsProvider>(context).brightness == Brightness.dark ? 'dark' : 'light';
    keepScreenOn = Provider.of<SettingsProvider>(context).keepScreenOn;
  }

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
              'Display',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SettingsRow(
              title: 'Text Size',
              description: 'Adjust lyrics text size',
              action: DropdownMenu(
                onSelected: (value) {
                  SettingsProviderTextSize textSizeValue = SettingsProviderTextSize.values.firstWhere(
                    (e) => e.name == value,
                    orElse: () => SettingsProviderTextSize.medium,
                  );

                  Provider.of<SettingsProvider>(context, listen: false).setTextSize(textSizeValue);

                  setState(() {
                    textSize = value!;
                  });
                },
                initialSelection: textSize,
                dropdownMenuEntries: <DropdownMenuEntry>[
                  DropdownMenuEntry(value: 'small', label: 'Small'),
                  DropdownMenuEntry(value: 'medium', label: 'Medium'),
                  DropdownMenuEntry(value: 'large', label: 'Large'),
                ],
              ),
            ),
            SettingsRow(
              title: 'Theme',
              description: 'Choose app appearance',
              action: DropdownMenu(
                onSelected: (value) {
                  Provider.of<SettingsProvider>(context, listen: false).setBrightness(
                    value == 'dark' ? Brightness.dark : Brightness.light,
                  );

                  setState(() {
                    theme = value!;
                  });
                },
                initialSelection: theme,
                dropdownMenuEntries: <DropdownMenuEntry>[
                  DropdownMenuEntry(value: 'light', label: 'Light'),
                  DropdownMenuEntry(value: 'dark', label: 'Dark'),
                ],
              ),
            ),
            SettingsRow(
              title: 'Keep Screen On',
              description: 'Prevent screen from sleeping',
              action: Switch(
                value: keepScreenOn,
                onChanged: (value) {
                  setState(() {
                    keepScreenOn = value;
                  });
                  Provider.of<SettingsProvider>(context, listen: false).setKeepScreenOn(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
