import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/components/AppBarWithProvider.dart';
import 'package:songbooksofpraise_app/pages/RootPage.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SettingsTab/components/AboutSection.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SettingsTab/components/DisplaySection.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SettingsTab/components/MusicAndAudioSection.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    const List<Widget> children = [
      DisplaySection(),
      MusicAndAudioSection(),
      AboutSection(),
    ];

    return Scaffold(
      appBar: AppBarWithProvider(settingsTabKey),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 12.0);
        },
        itemCount: children.length,
        itemBuilder: (context, index) {
          return children[index];
        },
      ),
    );
  }
}
