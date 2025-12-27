import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/pages/Tabs/HomeTab/HomeTab.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SettingsTab/SettingsTab.dart';
import 'package:songbooksofpraise_app/pages/Tabs/SongbooksTab/SongbookTab.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/components/TabNavigator.dart';

final homeTabKey = GlobalKey<NavigatorState>();
final songbookTabKey = GlobalKey<NavigatorState>();
// final favoritesTabKey = GlobalKey<NavigatorState>();
// final churchesTabKey = GlobalKey<NavigatorState>();
final settingsTabKey = GlobalKey<NavigatorState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTabIndex = 0;

  void setTabIndex(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: currentTabIndex,
        children: <Widget>[
          ChangeNotifierProvider(
            create: (_) => AppBarProvider(
              AppBarState(
                title: localizations.home,
                icon: Icons.home,
              ),
            ),
            child: const HomeTab(),
          ),
          ChangeNotifierProvider(
            create: (_) => AppBarProvider(
              AppBarState(
                title: localizations.songbooks,
                icon: Icons.library_books,
              ),
            ),
            child: const SongbookTab(),
          ),
          // TabNavigator(
          //   navigatorKey: churchesTabKey,
          //   child: ChangeNotifierProvider(
          //     create: (_) => AppBarProvider(
          //       AppBarState(
          //         title: localizations.churches,
          //         icon: Icons.church,
          //       ),
          //     ),
          //     child: const Text('Churches Tab'),
          //   ),
          // ),
          TabNavigator(
            navigatorKey: settingsTabKey,
            child: ChangeNotifierProvider(
              create: (_) => AppBarProvider(
                AppBarState(
                  title: localizations.settings,
                  icon: Icons.settings,
                ),
              ),
              child: SettingsTab(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: currentTabIndex,
          onTap: setTabIndex,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: localizations.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: localizations.songbooks,
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.favorite),
            //   label: 'Favorites',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.church),
            //   label: localizations.churches,
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: localizations.settings,
            ),
          ],
        ),
      ),
    );
  }
}
