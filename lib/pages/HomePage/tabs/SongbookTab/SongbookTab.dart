import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbookTab/components/SongbookSearchBar.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbookTab/components/SongbooksMenu.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/components/TabNavigator.dart';

class SongbookTab extends StatefulWidget {
  const SongbookTab({super.key});

  @override
  State<SongbookTab> createState() => _SongbookTabState();
}

class _SongbookTabState extends State<SongbookTab> {
  List<Songbook> installed = [];
  List<Songbook> available = [];

  @override
  void initState() {
    super.initState();

    onRefresh();
  }

  Future<void> onRefresh() async {
    // Simulate a network call or data refresh
    // await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        installed = Songbook.getInstalled();
      });
    }
  }

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
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: [
              const SongbookSearchBar(),
              SongbooksMenu(installed: installed, available: available),
            ],
          ),
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
