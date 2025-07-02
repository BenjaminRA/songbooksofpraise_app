import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/models/Songbook.dart';

class ActiveSongbookSection extends StatefulWidget {
  final Songbook songbook;

  const ActiveSongbookSection({super.key, required this.songbook});

  @override
  State<ActiveSongbookSection> createState() => ActiveSongbookSectionState();
}

class ActiveSongbookSectionState extends State<ActiveSongbookSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: Color.fromRGBO(254, 247, 218, 1.0), width: 2.0),
        ),
        // borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book, size: 18.0),
                  SizedBox(width: 8.0),
                  Text(
                    widget.songbook.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                '${widget.songbook.songCount} Songs • 12 categories • 48 subcategories',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
