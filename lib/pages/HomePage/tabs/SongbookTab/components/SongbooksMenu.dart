import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbookTab/components/SongbooksMenuAvailable.dart';
import 'package:songbooksofpraise_app/pages/HomePage/tabs/SongbookTab/components/SongbooksMenuInstalled.dart';

class SongbooksMenu extends StatefulWidget {
  final List<Songbook> installed;
  final List<Songbook> available;

  const SongbooksMenu({super.key, required this.installed, required this.available});

  @override
  State<SongbooksMenu> createState() => _SongbooksMenuState();
}

class _SongbooksMenuState extends State<SongbooksMenu> {
  // PageController pageController = PageController();
  int currentSongbookTabIndex = 0;

  void initState() {
    super.initState();

    // pageController.addListener(() {
    //   setState(() {
    //     currentSongbookTabIndex = pageController.page?.round() ?? 0;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    List<String> songbookTabs = ['Installed (${widget.installed.length})', 'Available (24)'];

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
        if (currentSongbookTabIndex == 0) SongbooksMenuInstalled(songbooks: widget.installed) else const SongbooksMenuAvailable(),
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
