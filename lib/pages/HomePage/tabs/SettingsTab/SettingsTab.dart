import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SettingsTab/components/AboutSection.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SettingsTab/components/DisplaySection.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SettingsTab/components/MusicAndAudioSection.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    final appBarState = context.watch<AppBarProvider>().state;
    final showBackButton = context.watch<AppBarProvider>().showBackButton;

    const List<Widget> children = [
      DisplaySection(),
      MusicAndAudioSection(),
      AboutSection(),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  homeTabKey.currentState?.pop();
                  Provider.of<AppBarProvider>(context, listen: false).popTitle();
                },
              )
            : null,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              appBarState.icon,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                appBarState.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
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
