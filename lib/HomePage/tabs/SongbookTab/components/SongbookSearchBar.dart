import 'package:flutter/material.dart';

class SongbookSearchBar extends StatefulWidget {
  const SongbookSearchBar({super.key});

  @override
  State<SongbookSearchBar> createState() => _SongbookSearchBarState();
}

class _SongbookSearchBarState extends State<SongbookSearchBar> {
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
      child: TextField(
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        decoration: InputDecoration(
          hintText: 'Search available songbooks',
          prefixIcon: const Icon(Icons.search, color: Color.fromRGBO(140, 147, 159, 1), size: 28),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: Color.fromRGBO(221, 225, 229, 1),
              width: 1.5,
            ),
          ),
        ),
        onChanged: (value) {
          // Handle search logic here
        },
      ),
    );
  }
}
