import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songbooksofpraise_app/Providers/AppBarProvider.dart';
import 'package:songbooksofpraise_app/models/Song.dart';
import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';

Widget renderSongs(BuildContext context, Song song, {void Function()? onPressed}) {
  return MaterialButton(
    elevation: 1.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    color: Colors.white,
    onPressed: onPressed,
    // () {
    // Provider.of<AppBarProvider>(context, listen: false).setTitle(
    //   AppBarState(
    //     title: 'Categories',
    //     icon: Icons.library_books,
    //   ),
    // );
    // songbookTabKey.currentState?.push(
    //   MaterialPageRoute(
    //     builder: (context) => CategoryPage(category: item),
    //   ),
    // );
    // },
    // onPressed: item.onPressed,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // if (category.icon != null)
          //   Container(
          //     decoration: BoxDecoration(
          //       color: item.color ?? Theme.of(context).primaryColor,
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     padding: const EdgeInsets.all(8.0),
          //     child: Icon(item.icon, color: Colors.white, size: 28.0),
          //   ),
          // if (item.icon != null) const SizedBox(width: 12.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(song.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ),
  );
}
