import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbooksofpraise_app/l10n/app_localizations.dart';
import 'package:songbooksofpraise_app/models/Song.dart';

class FontAdjustmentButtonBar extends StatelessWidget {
  final double actualFontSize;
  final void Function() onDecreaseFontSize;
  final void Function() onIncreaseFontSize;
  final bool isFavorite;
  final Function(bool value) onSetFavorite;

  const FontAdjustmentButtonBar({
    super.key,
    required this.actualFontSize,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
    required this.isFavorite,
    required this.onSetFavorite,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => onSetFavorite(!isFavorite),
            icon: Row(
              children: [
                Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: 4.0),
                Text(
                  localizations.favorite,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onDecreaseFontSize,
            icon: const Icon(
              FontAwesomeIcons.minus,
              size: 16.0,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 9.0),
            child: Icon(FontAwesomeIcons.a, size: 18.0, color: Theme.of(context).primaryColor),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onIncreaseFontSize,
            icon: const Icon(
              FontAwesomeIcons.plus,
              size: 16.0,
            ),
          )
        ],
      ),
    );
  }
}
