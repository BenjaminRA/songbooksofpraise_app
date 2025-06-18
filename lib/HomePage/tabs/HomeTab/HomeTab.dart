import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/HomeTab/components/PopularThisWeelSection.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/HomeTab/components/QuickAccessSection.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/HomeTab/components/RecentlyPlayedSection.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/HomeTab/components/SearchBar.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        HomePageSearchBar(),
        QuickAccessSection(),
        RecentlyPlayedSection(),
        PopularThisWeekSection(),
        SizedBox(height: 20.0),
      ],
    );
  }
}
