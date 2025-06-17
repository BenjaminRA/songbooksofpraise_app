import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/HomePage/components/PopularThisWeelSection.dart';
import 'package:songbooksofpraise_app/HomePage/components/QuickAccessSection.dart';
import 'package:songbooksofpraise_app/HomePage/components/RecentlyPlayedSection.dart';
import 'package:songbooksofpraise_app/HomePage/components/SearchBar.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const HomePageSearchBar(),
        const QuickAccessSection(),
        const RecentlyPlayedSection(),
        const PopularThisWeekSection(),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
