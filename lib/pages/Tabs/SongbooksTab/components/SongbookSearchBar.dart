import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';

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
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        // onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: localizations.searchAvailableSongbooks,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
