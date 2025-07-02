import 'package:flutter/material.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar(
        //   title: Row(
        //     mainAxisSize: MainAxisSize.max,
        //     children: [
        //       Icon(
        //         Icons.library_books,
        //         color: Theme.of(context).primaryColor,
        //       ),
        //       const SizedBox(width: 10),
        //       Flexible(
        //         child: Text(
        //           'Songbooks',
        //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //           maxLines: 2,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
