import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';

class HomePageSearchBar extends StatefulWidget {
  const HomePageSearchBar({super.key});

  @override
  State<HomePageSearchBar> createState() => _HomePageSearchBarState();
}

class _HomePageSearchBarState extends State<HomePageSearchBar> {
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
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
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
        onChanged: (value) {
          // Handle search logic here
        },
      ),
    );
  }
}
