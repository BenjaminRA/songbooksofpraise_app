import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';

class SongSearch extends StatefulWidget {
  const SongSearch({super.key});

  @override
  State<SongSearch> createState() => _SongSearchState();
}

class _SongSearchState extends State<SongSearch> {
  final TextEditingController _searchController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();

  //   // Focus on _searchController input
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     FocusScope.of(context).requestFocus(FocusNode());
  //   });
  // }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: 'song-search',
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(
                    horizontal: BorderSide(color: Color.fromRGBO(254, 247, 218, 1.0), width: 2.0),
                  ),
                  // borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  autofocus: true,
                  controller: _searchController,
                  // onChanged: widget.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: localizations.searchHymnsSongsOrNumbers,
                    prefixIcon: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back, color: Color.fromRGBO(140, 147, 159, 1), size: 28),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(221, 225, 229, 1),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
