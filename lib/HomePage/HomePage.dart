import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/HomeTab/HomeTab.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SettingsTab/SettingsTab.dart';

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
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              const [
                Icons.menu_book_sharp,
                Icons.library_books,
                Icons.favorite,
                Icons.settings,
              ][currentTabIndex],
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                const [
                  'Songbooks of Praise',
                  'Manage Songbooks',
                  'Favorites',
                  'Settings',
                ][currentTabIndex],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: setTabIndex,
        children: const <Widget>[
          HomeTab(),
          Center(child: Text('Songbooks Tab')),
          Center(child: Text('Favorites Tab')),
          SettingsTab(),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
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
