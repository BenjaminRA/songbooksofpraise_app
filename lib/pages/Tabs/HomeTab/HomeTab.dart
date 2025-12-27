import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/components/AppBarWithProvider.dart';
import 'package:songbooksofpraise_app/pages/RootPage.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/components/PopularThisWeelSection.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/components/ExploreSection.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/components/RecentlyPlayedSection.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/components/HomePageSearchBar.dart';
import 'package:songbooksofpraise_app/components/TabNavigator.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithProvider(homeTabKey),
      body: TabNavigator(
        navigatorKey: homeTabKey,
        child: Column(
          children: [
            HomePageSearchBar(),
            Expanded(
              child: ListView(
                children: const <Widget>[
                  ExploreSection(),
                  RecentlyPlayedSection(),
                  PopularThisWeekSection(),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
