import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/TabNavigatorProvider.dart';
import 'package:songbooksofpraise_app/components/AppBarWithProvider.dart';
import 'package:songbooksofpraise_app/components/PullToRefresh.dart';
import 'package:songbooksofpraise_app/helpers/routeAwareMixin.dart';
import 'package:songbooksofpraise_app/pages/RootPage.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/components/ExploreSection.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/components/RecentlyPlayedSection.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/components/HomePageSearchBar.dart';
import 'package:songbooksofpraise_app/components/TabNavigator.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with RouteAwareMixin {
  Key _refreshKey = UniqueKey();

  @override
  Future<void> onBackFromAnotherTab() async {
    _refreshHome();
  }

  void _refreshHome() {
    setState(() {
      _refreshKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithProvider(homeTabKey),
      body: TabNavigator(
        navigatorKey: homeTabKey,
        onPopToInitialRoute: _refreshHome,
        child: Column(
          children: [
            HomePageSearchBar(),
            Expanded(
              child: PullToRefresh(
                slivers: [
                  SliverList(
                    key: _refreshKey,
                    delegate: SliverChildListDelegate(const <Widget>[
                      ExploreSection(),
                      RecentlyPlayedSection(),
                      // PopularThisWeekSection(),
                      SizedBox(height: 20.0),
                    ]),
                  ),
                ],
                onRefresh: () async => _refreshHome(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
