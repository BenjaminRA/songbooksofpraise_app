import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/HomeTab/HomeTab.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SettingsTab/SettingsTab.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbookTab/SongbookTab.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/components/TabNavigator.dart';

final homeTabKey = GlobalKey<NavigatorState>();
final songbookTabKey = GlobalKey<NavigatorState>();
// final favoritesTabKey = GlobalKey<NavigatorState>();
final churchesTabKey = GlobalKey<NavigatorState>();
final settingsTabKey = GlobalKey<NavigatorState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTabIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  void setTabIndex(int index) {
    pageController.jumpToPage(index);
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: setTabIndex,
        children: <Widget>[
          ChangeNotifierProvider(
            create: (_) => AppBarProvider(
              AppBarState(
                title: 'Home',
                icon: Icons.home,
              ),
            ),
            child: const HomeTab(),
          ),
          ChangeNotifierProvider(
            create: (_) => AppBarProvider(
              AppBarState(
                title: 'Songbooks',
                icon: Icons.library_books,
              ),
            ),
            child: const SongbookTab(),
          ),
          // TabNavigator(
          //   navigatorKey: favoritesTabKey,
          //   child: ChangeNotifierProvider(
          //     create: (_) => AppBarProvider(
          //       AppBarState(
          //         title: 'Favorites',
          //         icon: Icons.favorite,
          //       ),
          //     ),
          //     child: const Text('Favorites Tab'),
          //   ),
          // ),
          TabNavigator(
            navigatorKey: churchesTabKey,
            child: ChangeNotifierProvider(
              create: (_) => AppBarProvider(
                AppBarState(
                  title: 'Churches',
                  icon: Icons.church,
                ),
              ),
              child: const Text('Churches Tab'),
            ),
          ),
          TabNavigator(
            navigatorKey: settingsTabKey,
            child: ChangeNotifierProvider(
              create: (_) => AppBarProvider(
                AppBarState(
                  title: 'Settings',
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Songbooks',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.favorite),
            //   label: 'Favorites',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.church),
              label: 'Churches',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
