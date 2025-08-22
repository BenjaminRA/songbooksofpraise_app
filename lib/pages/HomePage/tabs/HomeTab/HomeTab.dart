import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/HomeTab/components/PopularThisWeelSection.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/HomeTab/components/ExploreSection.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/HomeTab/components/RecentlyPlayedSection.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/HomeTab/components/HomePageSearchBar.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/components/TabNavigator.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final appBarState = context.watch<AppBarProvider>().state;
    final showBackButton = context.watch<AppBarProvider>().showBackButton;

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
