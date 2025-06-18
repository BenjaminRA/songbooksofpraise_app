import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SettingsTab/components/SettingsRow.dart';

class DisplaySection extends StatefulWidget {
  const DisplaySection({super.key});

  @override
  State<DisplaySection> createState() => _DisplaySectionState();
}

class _DisplaySectionState extends State<DisplaySection> {
  bool keepScreenOn = true;

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
                initialSelection: 'medium',
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
                initialSelection: 'light',
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
                onChanged: (value) => setState(() => keepScreenOn = value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
