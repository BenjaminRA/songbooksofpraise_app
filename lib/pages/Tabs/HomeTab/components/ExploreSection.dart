import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/api/api.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';

class ExploreSectionItem {
  final IconData icon;
  final String label;
  final String subLabel;
  final Color color;
  final VoidCallback onPressed;

  ExploreSectionItem({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.color,
    required this.onPressed,
  });
}

class ExploreSection extends StatefulWidget {
  const ExploreSection({super.key});

  @override
  State<ExploreSection> createState() => _ExploreSectionState();
}

class _ExploreSectionState extends State<ExploreSection> {
  List<Widget> _exploreItems(AppLocalizations localizations) {
    List<ExploreSectionItem> items = [
      ExploreSectionItem(
        icon: Icons.list,
        label: localizations.browse,
        subLabel: localizations.categories,
        color: const Color.fromRGBO(119, 24, 40, 1.0),
        onPressed: () {},
      ),
      ExploreSectionItem(
        icon: Icons.menu_book,
        label: localizations.songbooks,
        subLabel: localizations.manage,
        color: const Color.fromRGBO(201, 161, 42, 1.0),
        onPressed: () {},
      ),
      ExploreSectionItem(
        icon: Icons.access_time_filled,
        label: localizations.recent,
        subLabel: localizations.lastPlayed,
        color: const Color.fromRGBO(47, 105, 243, 1.0),
        onPressed: () {},
      ),
      ExploreSectionItem(
        icon: Icons.favorite,
        label: localizations.favorites,
        subLabel: localizations.songsCount(21),
        color: const Color.fromRGBO(232, 43, 53, 1.0),
        onPressed: () {},
      ),
    ];

    return items.map((item) {
      return MaterialButton(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        onPressed: item.onPressed,
        child: Container(
          width: 146.0,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(item.icon, color: Colors.white, size: 28.0),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                    ),
                    Text(
                      item.subLabel,
                      style: Theme.of(context).textTheme.labelSmall,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizations.explore,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 16.0,
            children: _exploreItems(localizations),
          ),
        )
      ],
    );
  }
}
