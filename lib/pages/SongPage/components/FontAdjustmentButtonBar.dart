import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FontAdjustmentButtonBar extends StatelessWidget {
  final double actualFontSize;
  final void Function() onDecreaseFontSize;
  final void Function() onIncreaseFontSize;

  const FontAdjustmentButtonBar({
    super.key,
    required this.actualFontSize,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
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
