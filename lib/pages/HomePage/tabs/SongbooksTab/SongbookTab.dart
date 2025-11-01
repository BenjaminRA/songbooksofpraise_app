import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbooksTab/components/SongbookSearchBar.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbooksTab/components/SongbooksMenu.dart';
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
      final response = await API.get('songbooks');
      final available = await Songbook.fromJson(response['songbooks']);

      final installed = await Songbook.getInstalled();

      setState(() {
        this.available = available;
        this.installed = installed;
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
            if (appBarState.icon != null)
              Icon(
                appBarState.icon,
                color: Theme.of(context).primaryColor,
              ),
            if (appBarState.icon != null) const SizedBox(width: 10),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appBarState.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                  ),
                  if (appBarState.subtitle != null)
                    Text(
                      appBarState.subtitle!,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabNavigator(
        navigatorKey: songbookTabKey,
        child: Column(
          children: [
            const SongbookSearchBar(),
            Expanded(
              child: SongbooksMenu(
                onRefresh: onRefresh,
                installed: installed,
                available: available,
              ),
            ),
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
