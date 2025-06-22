import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SongbookTab/components/SongbooksMenuAvailable.dart';
import 'package:songbooksofpraise_app/HomePage/tabs/SongbookTab/components/SongbooksMenuInstalled.dart';

class SongbooksMenu extends StatefulWidget {
  const SongbooksMenu({super.key});

  @override
  State<SongbooksMenu> createState() => _SongbooksMenuState();
}

class _SongbooksMenuState extends State<SongbooksMenu> {
  // PageController pageController = PageController();
  int currentSongbookTabIndex = 0;
  final List<String> songbookTabs = ['Installed (6)', 'Available (24)'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: songbookTabs.map((tab) {
              int index = songbookTabs.indexOf(tab);

              return Flexible(
                fit: FlexFit.tight,
                child: GestureDetector(
                  onTap: () {
                    // pageController.jumpToPage(index);
                    setState(() {
                      currentSongbookTabIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      // color: currentSongbookTabIndex == index ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                      // borderRadius: BorderRadius.circular(8.0),
                      border: Border(
                        bottom: BorderSide(
                          color: currentSongbookTabIndex == index ? Theme.of(context).primaryColor : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Text(
                      tab,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: currentSongbookTabIndex == index ? Theme.of(context).primaryColor : Colors.grey[700],
                          ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (currentSongbookTabIndex == 0) const SongbooksMenuInstalled() else const SongbooksMenuAvailable(),
        // PageView(
        //   physics: const NeverScrollableScrollPhysics(),
        //   controller: pageController,
        //   onPageChanged: (index) {
        //     setState(() {
        //       currentSongbookTabIndex = index;
        //     });
        //   },
        //   children: const [
        //     SongbooksMenuInstalled(),
        //     SongbooksMenuAvailable(),
        //   ],
        // )
      ],
    );
  }
}
