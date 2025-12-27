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
    double boxSize = 35.0;

    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecreaseFontSize,
            child: Container(
              height: boxSize,
              width: boxSize,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
              child: const Icon(FontAwesomeIcons.minus, size: 16.0),
            ),
          ),
          Container(
            height: boxSize,
            width: boxSize,
            decoration: BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(color: Theme.of(context).primaryColor)),
            ),
            alignment: Alignment.center,
            child: Icon(FontAwesomeIcons.a, size: 18.0, color: Theme.of(context).primaryColor),
            // child: Text(
            //   actualFontSize.toInt().toString(),
            //   style: TextStyle(
            //     fontSize: 14.0,
            //     fontWeight: FontWeight.w500,
            //     color: Theme.of(context).primaryColor,
            //   ),
            // ),
          ),
          GestureDetector(
            onTap: onIncreaseFontSize,
            child: Container(
              height: boxSize,
              width: boxSize,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: const Icon(FontAwesomeIcons.plus, size: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
