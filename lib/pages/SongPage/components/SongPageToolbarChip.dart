import 'package:flutter/material.dart';

class SongPageToolbarChip extends StatelessWidget {
  final bool disabled;
  final bool selected;
  final String label;
  final IconData? icon;
  final VoidCallback onSelected;

  const SongPageToolbarChip({super.key, this.disabled = false, this.selected = false, required this.label, this.icon, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !disabled ? onSelected : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: disabled
              ? Colors.grey
              : selected
                  ? Theme.of(context).primaryColor
                  : Colors.white,
          border: Border.all(
              color: disabled
                  ? Colors.grey
                  : selected
                      ? Colors.white
                      : Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16.0,
                  color: disabled
                      ? Colors.grey[200]
                      : selected
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 6.0),
              ],
              Text(
                label,
                style: TextStyle(
                  color: disabled
                      ? Colors.grey[200]
                      : selected
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
