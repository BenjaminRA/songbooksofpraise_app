import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/pages/RootPage.dart';
import 'package:songbooksofpraise_app/pages/SongSearch/SongSearch.dart';

class SongbookSearchBar extends StatefulWidget {
  // final Function(String) onSearchChanged;

  const SongbookSearchBar({
    super.key,
    // required this.onSearchChanged,
  });

  @override
  State<SongbookSearchBar> createState() => _SongbookSearchBarState();
}

class _SongbookSearchBarState extends State<SongbookSearchBar> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

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
        // controller: _searchController,
        // onChanged: widget.onSearchChanged,
        onTap: () {
          globalNavigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => const SongSearch()));
        },
        decoration: InputDecoration(
          hintText: localizations.searchHymnsSongsOrNumbers,
          prefixIcon: const Icon(Icons.search, color: Color.fromRGBO(140, 147, 159, 1), size: 28),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: Color.fromRGBO(221, 225, 229, 1),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
