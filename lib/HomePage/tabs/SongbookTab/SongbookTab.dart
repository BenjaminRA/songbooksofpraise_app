import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SongbookTab/components/ActiveSongbookSection.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SongbookTab/components/CategoriesSection.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SongbookTab/components/SongbookSearchBar.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SongbookTab/components/SongbooksMenu.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/components/TabNavigator.dart';

class SongbookTab extends StatefulWidget {
  const SongbookTab({super.key});

  @override
  State<SongbookTab> createState() => _SongbookTabState();
}

class _SongbookTabState extends State<SongbookTab> {
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
                  songbookTabKey.currentState?.pop();
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
        navigatorKey: songbookTabKey,
        child: ListView(
          children: const [
            SongbookSearchBar(),
            SongbooksMenu(),
            // Hero(tag: 'active_songbook', child: ActiveSongbookSection()),
            // CategoriesSection(),
          ],
        ),
      ),
    );
    // return ListView(
    //   children: [
    //     AppBar(
    //       title: Row(
    //         mainAxisSize: MainAxisSize.max,
    //         children: [
    //           Icon(
    //             Icons.library_books,
    //             color: Theme.of(context).primaryColor,
    //           ),
    //           const SizedBox(width: 10),
    //           Flexible(
    //             child: Text(
    //               'Songbooks',
    //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //               maxLines: 2,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     ActiveSongbookSection(),
    //     CategoriesSection(),
    //   ],
    // );
  }
}
